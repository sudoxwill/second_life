import "dart:io";

import "package:camera/camera.dart";
import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/index.dart";
import "../../../../shared/presentation/widgets/others/feedback_views.dart";
import "../../../../shared/presentation/widgets/others/scan_widgets.dart";
import "analysis_result_page.dart";

// Prise de vue du déchet avec aperçu caméra en direct. Sans caméra (refus
// de la permission, ordinateur…), seul l'import depuis la galerie reste.
class WasteScanPage extends StatefulWidget {
  const WasteScanPage({super.key});

  @override
  State<WasteScanPage> createState() => _WasteScanPageState();
}

class _WasteScanPageState extends State<WasteScanPage>
    with WidgetsBindingObserver {
  final _picker = ImagePicker();
  CameraController? _camera;
  // La demande de permission fait passer l'app par inactive / resumed :
  // évite de lancer une seconde initialisation pendant la première.
  bool _initializing = false;
  bool _cameraFailed = false;
  bool _capturing = false;
  bool _flashOn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _camera?.dispose();
    super.dispose();
  }

  // La caméra est libérée quand l'app passe en arrière-plan.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final camera = _camera;
    if (state == AppLifecycleState.inactive && camera != null) {
      _camera = null;
      camera.dispose();
      if (mounted) setState(() {});
    } else if (state == AppLifecycleState.resumed &&
        camera == null &&
        !_cameraFailed) {
      _initCamera();
    }
  }

  Future<void> _initCamera() async {
    if (_initializing) return;
    _initializing = true;
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) throw CameraException("none", "Aucune caméra");
      final back = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      final controller = CameraController(
        back,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      await controller.initialize();
      await controller.setFlashMode(FlashMode.off);
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() {
        _camera = controller;
        _cameraFailed = false;
        _flashOn = false;
      });
    } catch (_) {
      if (mounted) setState(() => _cameraFailed = true);
    } finally {
      _initializing = false;
    }
  }

  Future<void> _capture() async {
    final camera = _camera;
    if (camera == null || _capturing || camera.value.isTakingPicture) return;
    setState(() => _capturing = true);
    try {
      final photo = await camera.takePicture();
      _openAnalysis(File(photo.path));
    } catch (_) {
      if (mounted) {
        showAppSnackBar(
          context,
          context.l10n.scanCaptureError,
          error: true,
        );
        setState(() => _capturing = false);
      }
    }
  }

  Future<void> _importFromGallery() async {
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        imageQuality: 85,
      );
      if (picked != null) _openAnalysis(File(picked.path));
    } catch (_) {
      if (mounted) {
        showAppSnackBar(context, context.l10n.scanGalleryError, error: true);
      }
    }
  }

  Future<void> _toggleFlash() async {
    final camera = _camera;
    if (camera == null) return;
    final on = !_flashOn;
    try {
      await camera.setFlashMode(on ? FlashMode.torch : FlashMode.off);
      if (mounted) setState(() => _flashOn = on);
    } catch (_) {
      // Pas de flash sur cet appareil.
    }
  }

  void _openAnalysis(File image) {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(
        builder: (_) => AnalysisResultPage(image: image),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final camera = _camera;
    final ready = camera != null && camera.value.isInitialized;

    return Scaffold(
      backgroundColor: AppColors.scanBackground,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (ready) _CameraPreviewCover(controller: camera),
          // Cadre centré : son voile assombrit tout autour, il doit donc
          // être peint avant l'en-tête et le déclencheur.
          SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ScanFrame(
                    size: 270,
                    dimOutside: ready,
                    scanning: !_cameraFailed,
                    child: ready ? null : _placeholder(),
                  ),
                  AppSpacing.gapVXxl,
                  ScanHint(
                    _cameraFailed ? l10n.scanHintImport : l10n.scanHintFrame,
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.md,
                    AppSpacing.lg,
                    0,
                  ),
                  child: Row(
                    children: [
                      ScanRoundButton(
                        icon: Icons.arrow_back_rounded,
                        tooltip: l10n.commonBack,
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      ScanChip(
                        icon: Icons.auto_awesome_rounded,
                        label: l10n.scanAiBranding,
                      ),
                      const Spacer(),
                      ScanRoundButton(
                        icon: Icons.file_upload_outlined,
                        tooltip: l10n.scanTooltipImport,
                        onPressed: _importFromGallery,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.xxxl,
                    0,
                    AppSpacing.xxxl,
                    AppSpacing.xxxl,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ScanRoundButton(
                        icon: _flashOn
                            ? Icons.flashlight_on_rounded
                            : Icons.flashlight_off_outlined,
                        tooltip: l10n.scanTooltipFlash,
                        onPressed: ready ? _toggleFlash : null,
                      ),
                      _ShutterButton(
                        loading: _capturing,
                        onPressed: ready ? _capture : _importFromGallery,
                        tooltip: l10n.scanTooltipCapture,
                      ),
                      // Équilibre la lampe, à gauche du déclencheur.
                      const SizedBox(width: AppSpacing.tapTargetMin),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_cameraFailed)
            Icon(
              Icons.no_photography_outlined,
              size: AppSpacing.iconXxxl,
              color: Colors.white.withValues(alpha: 0.35),
            )
          else
            const SizedBox.square(
              dimension: AppSpacing.xxxl,
              child: CircularProgressIndicator(
                color: AppColors.scanFrame,
                strokeWidth: 2.5,
              ),
            ),
          AppSpacing.gapVMd,
          Text(
            _cameraFailed ? l10n.scanCameraUnavailable : l10n.scanCameraOpening,
            textAlign: TextAlign.center,
            style: textTheme.labelMedium!.copyWith(
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

// Aperçu caméra qui remplit l'écran sans être déformé (rogné si besoin).
class _CameraPreviewCover extends StatelessWidget {
  const _CameraPreviewCover({required this.controller});
  final CameraController controller;

  @override
  Widget build(BuildContext context) {
    final previewSize = controller.value.previewSize;
    if (previewSize == null) return const SizedBox.shrink();
    // previewSize est en paysage : on l'inverse pour le portrait.
    return ClipRect(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: previewSize.height,
          height: previewSize.width,
          child: CameraPreview(controller),
        ),
      ),
    );
  }
}

class _ShutterButton extends StatelessWidget {
  const _ShutterButton({
    required this.loading,
    required this.onPressed,
    required this.tooltip,
  });
  final bool loading;
  final VoidCallback onPressed;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: loading ? null : onPressed,
        child: Container(
          width: 84,
          height: 84,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: AppSpacing.borderWidthThick,
            ),
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: EdgeInsets.all(loading ? 6 : 0),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: loading
                ? const Padding(
                    padding: EdgeInsets.all(18),
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : const Icon(
                    Icons.photo_camera_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
          ),
        ),
      ),
    );
  }
}
