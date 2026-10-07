import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../../shared/presentation/providers/core_providers.dart";
import "../../data/datasources/ticket_validation_remote_datasource.dart";
import "../../data/repositories/ticket_validation_repository_impl.dart";
import "../../domain/repositories/ticket_validation_repository.dart";
import "../../domain/usecases/get_agent_history.dart";
import "../../domain/usecases/get_current_relay_agent.dart";
import "../../domain/usecases/get_pending_tickets.dart";
import "../../domain/usecases/get_ticket_by_code.dart";
import "../../domain/usecases/reject_ticket.dart";
import "../../domain/usecases/validate_ticket.dart";

part "ticket_validation_providers.g.dart";

@Riverpod(keepAlive: true)
TicketValidationRemoteDatasource ticketValidationRemoteDatasource(Ref ref) =>
    TicketValidationRemoteDatasourceImpl(
      ref.watch(firebaseFirestoreProvider),
      ref.watch(firebaseAuthProvider),
    );

@Riverpod(keepAlive: true)
TicketValidationRepository ticketValidationRepository(Ref ref) =>
    TicketValidationRepositoryImpl(
      ref.watch(ticketValidationRemoteDatasourceProvider),
    );

@Riverpod(keepAlive: true)
GetCurrentRelayAgent getCurrentRelayAgent(Ref ref) =>
    GetCurrentRelayAgent(ref.watch(ticketValidationRepositoryProvider));

@Riverpod(keepAlive: true)
GetTicketByCode getTicketByCode(Ref ref) =>
    GetTicketByCode(ref.watch(ticketValidationRepositoryProvider));

@Riverpod(keepAlive: true)
ValidateTicket validateTicket(Ref ref) =>
    ValidateTicket(ref.watch(ticketValidationRepositoryProvider));

@Riverpod(keepAlive: true)
RejectTicket rejectTicket(Ref ref) =>
    RejectTicket(ref.watch(ticketValidationRepositoryProvider));

@Riverpod(keepAlive: true)
GetAgentHistory getAgentHistory(Ref ref) =>
    GetAgentHistory(ref.watch(ticketValidationRepositoryProvider));

@Riverpod(keepAlive: true)
GetPendingTickets getPendingTickets(Ref ref) =>
    GetPendingTickets(ref.watch(ticketValidationRepositoryProvider));
