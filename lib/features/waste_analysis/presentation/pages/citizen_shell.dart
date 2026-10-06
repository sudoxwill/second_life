import "package:flutter/material.dart";

import "../../../../shared/presentation/widgets/others/app_shell.dart";
import "citizen_history_page.dart";
import "citizen_home_page.dart";
import "citizen_profile_page.dart";
import "relay_map_page.dart";
import "waste_scan_page.dart";

// Espace de l'usager : Accueil, Carte, [scan], Historique, Profil.
class CitizenShell extends StatefulWidget {
  const CitizenShell({super.key});

  @override
  State<CitizenShell> createState() => _CitizenShellState();
}

class _CitizenShellState extends State<CitizenShell> {
  static const _mapTab = 1;
  static const _historyTab = 2;

  int _index = 0;

  void _scan() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => const WasteScanPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      index: _index,
      onIndexChanged: (i) => setState(() => _index = i),
      centerIcon: Icons.photo_camera_rounded,
      centerTooltip: "Scanner un déchet",
      onCenterPressed: _scan,
      destinations: [
        ShellDestination(
          label: "Accueil",
          icon: Icons.home_outlined,
          selectedIcon: Icons.home_rounded,
          page: CitizenHomePage(
            onScan: _scan,
            onOpenMap: () => setState(() => _index = _mapTab),
            onOpenHistory: () => setState(() => _index = _historyTab),
          ),
        ),
        const ShellDestination(
          label: "Carte",
          icon: Icons.place_outlined,
          selectedIcon: Icons.place_rounded,
          page: RelayMapPage(),
        ),
        const ShellDestination(
          label: "Historique",
          icon: Icons.history_rounded,
          selectedIcon: Icons.history_rounded,
          page: CitizenHistoryPage(),
        ),
        const ShellDestination(
          label: "Profil",
          icon: Icons.person_outline_rounded,
          selectedIcon: Icons.person_rounded,
          page: CitizenProfilePage(),
        ),
      ],
    );
  }
}
