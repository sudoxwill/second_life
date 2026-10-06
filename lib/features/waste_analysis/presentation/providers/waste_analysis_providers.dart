import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../../shared/presentation/providers/core_providers.dart";
import "../../data/datasources/recycling_ticket_remote_datasource.dart";
import "../../data/datasources/waste_analysis_remote_datasource.dart";
import "../../data/repositories/waste_analysis_repository_impl.dart";
import "../../domain/repositories/waste_analysis_repository.dart";
import "../../domain/usecases/analyze_waste_photo.dart";
import "../../domain/usecases/get_user_tickets.dart";
import "../../domain/usecases/submit_waste_info.dart";

part "waste_analysis_providers.g.dart";

@Riverpod(keepAlive: true)
WasteAnalysisRemoteDatasource wasteAnalysisRemoteDatasource(Ref ref) =>
    WasteAnalysisRemoteDatasourceImpl(ref.watch(dioProvider));

@Riverpod(keepAlive: true)
RecyclingTicketRemoteDatasource recyclingTicketRemoteDatasource(Ref ref) =>
    RecyclingTicketRemoteDatasourceImpl(
      ref.watch(firebaseFirestoreProvider),
      ref.watch(firebaseAuthProvider),
    );

@Riverpod(keepAlive: true)
WasteAnalysisRepository wasteAnalysisRepository(Ref ref) =>
    WasteAnalysisRepositoryImpl(
      ref.watch(wasteAnalysisRemoteDatasourceProvider),
      ref.watch(recyclingTicketRemoteDatasourceProvider),
    );

@Riverpod(keepAlive: true)
AnalyzeWastePhoto analyzeWastePhoto(Ref ref) =>
    AnalyzeWastePhoto(ref.watch(wasteAnalysisRepositoryProvider));

@Riverpod(keepAlive: true)
SubmitWasteInfo submitWasteInfo(Ref ref) =>
    SubmitWasteInfo(ref.watch(wasteAnalysisRepositoryProvider));

@Riverpod(keepAlive: true)
GetUserTickets getUserTickets(Ref ref) =>
    GetUserTickets(ref.watch(wasteAnalysisRepositoryProvider));
