import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/themes/app_theme.dart';
import '../../core/localization/app_localizations.dart';
import '../widgets/custom_sidebar.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';

class BookingRequestsScreen extends StatefulWidget {
  const BookingRequestsScreen({Key? key}) : super(key: key);

  @override
  State<BookingRequestsScreen> createState() => _BookingRequestsScreenState();
}

class _BookingRequestsScreenState extends State<BookingRequestsScreen> {

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLawyer = state is AuthenticatedLawyer;
        final titleKey = isLawyer ? 'booking_requests' : 'my_bookings';
        
        return Scaffold(
          backgroundColor: AppTheme.background,
          drawer: const CustomSidebar(),
          appBar: AppBar(
            backgroundColor: AppTheme.surface,
            elevation: 0,
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.gavel, color: AppTheme.primary),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            title: Text(
              l10n.translate(titleKey),
              style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(l10n, isLawyer),
                  const SizedBox(height: 40),
                  _buildStatusPills(l10n),
                  const SizedBox(height: 32),
                  _buildRequestList(l10n, isLawyer),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(AppLocalizations l10n, bool isLawyer) {
    final titleKey = isLawyer ? 'booking_requests' : 'my_bookings';
    final descKey = isLawyer ? 'manage_incoming_mandates' : 'manage_your_bookings';
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              l10n.translate(titleKey).split(' ').first,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.translate(titleKey).split(' ').length > 1
                    ? l10n.translate(titleKey).split(' ').sublist(1).join(' ')
                    : '',
                style: const TextStyle(
                  color: AppTheme.primary,
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          l10n.translate(descKey),
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 16,
            height: 1.5,
          ),
        ),
      ],
    );
  }


  Widget _buildStatusPills(AppLocalizations l10n) {
    return Row(
      children: [
        _statusPill("4 ${l10n.translate('confirmed')}", Colors.green),
        const SizedBox(width: 12),
        _statusPill("2 ${l10n.translate('pending')}", AppTheme.primary),
      ],
    );
  }

  Widget _statusPill(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestList(AppLocalizations l10n, bool isLawyer) {
    return Column(
      children: [
        _buildRequestCard(
          name: isLawyer ? "Malek Al-Sayed" : "Adv. Ahmed Hassan",
          specialization: l10n.translate('commercial_arbitration'),
          time: "Today, 14:30 EET",
          status: l10n.translate('pending_review'),
          statusColor: AppTheme.primary,
          caseBrief: "Asset Liquidation Dispute",
          caseDesc: "A complex dispute regarding the dissolution of a multi-national shipping conglomerate based in Alexandria. Client seeks urgent counsel on Egyptian maritime tax implications and board liability protection.",
          isNew: true,
          l10n: l10n,
          isLawyer: isLawyer,
        ),
        const SizedBox(height: 24),
        _buildSimplifiedCard(
          name: isLawyer ? "Hala Mansour" : "Adv. Layla Kamel",
          time: "TOMORROW, 09:00",
          status: l10n.translate('confirmed'),
          statusColor: Colors.teal,
          description: isLawyer 
              ? "Inquiry regarding intellectual property filing for a Cairo-based tech startup."
              : "Reviewing company registration documents and trademark protection strategies.",
          actionLabel: isLawyer ? l10n.translate('view_file') : l10n.translate('request_details'),
        ),
        const SizedBox(height: 24),
        _buildSimplifiedCard(
          name: isLawyer ? "Karim Abadi" : "Adv. Mahmoud Zaid",
          time: "24 OCT, 11:15",
          status: l10n.translate('completed'),
          statusColor: Colors.blueGrey,
          description: isLawyer
              ? "Real Estate litigation - Dokki District Court findings and next steps."
              : "Finalizing inheritance documents and property transfer for the Giza estate.",
          actionLabel: isLawyer ? l10n.translate('archive') : l10n.translate('request_details'),
        ),
      ],
    );
  }

  Widget _buildRequestCard({
    required String name,
    required String specialization,
    required String time,
    required String status,
    required Color statusColor,
    required String caseBrief,
    required String caseDesc,
    required AppLocalizations l10n,
    bool isNew = false,
    bool isLawyer = true,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(isLawyer ? "https://i.pravatar.cc/150?img=11" : "https://i.pravatar.cc/150?img=12"),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      specialization,
                      style: const TextStyle(color: AppTheme.primary, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(time, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: statusColor.withOpacity(0.3)),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(color: statusColor, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            "${l10n.translate('case_brief_label')} $caseBrief",
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            caseDesc,
            style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              if (isLawyer) ...[
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.check_circle, size: 18),
                    label: Text(l10n.translate('accept_mandate')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.withOpacity(0.1),
                      foregroundColor: Colors.teal,
                      elevation: 0,
                      minimumSize: const Size(0, 56),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.cancel, size: 18),
                    label: Text(l10n.translate('reject')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent.withOpacity(0.1),
                      foregroundColor: Colors.redAccent,
                      elevation: 0,
                      minimumSize: const Size(0, 56),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    ),
                  ),
                ),
              ] else ...[
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.info_outline, size: 18),
                    label: Text(l10n.translate('request_details')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary.withOpacity(0.1),
                      foregroundColor: AppTheme.primary,
                      elevation: 0,
                      minimumSize: const Size(0, 56),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.cancel_outlined, size: 18),
                    label: Text(l10n.translate('cancel_request')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent.withOpacity(0.1),
                      foregroundColor: Colors.redAccent,
                      elevation: 0,
                      minimumSize: const Size(0, 56),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSimplifiedCard({
    required String name,
    required String time,
    required String status,
    required Color statusColor,
    required String description,
    required String actionLabel,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant.withOpacity(0.2),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(time, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: TextStyle(color: statusColor, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(description, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {},
            child: Text(actionLabel),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.05),
              foregroundColor: Colors.white.withOpacity(0.8),
              elevation: 0,
              minimumSize: const Size(double.infinity, 44),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ],
      ),
    );
  }
}
