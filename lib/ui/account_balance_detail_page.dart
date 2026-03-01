import 'package:flutter/material.dart';

import 'account_balances_page.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Model
// ─────────────────────────────────────────────────────────────────────────────

class TransactionEntry {
  const TransactionEntry({
    required this.type,
    required this.category,
    required this.date,
    required this.amount,
    required this.currency,
    this.hasCheckImages = false,
  });

  final String type;
  final String category;
  final String date;
  final String amount;
  final String currency;
  final bool hasCheckImages;
}

// ─────────────────────────────────────────────────────────────────────────────
// Page
// ─────────────────────────────────────────────────────────────────────────────

class AccountBalanceDetailPage extends StatefulWidget {
  const AccountBalanceDetailPage({
    super.key,
    required this.account,
    required this.accountIndex,
    required this.totalAccounts,
  });

  final AccountEntry account;
  final int accountIndex;
  final int totalAccounts;

  @override
  State<AccountBalanceDetailPage> createState() =>
      _AccountBalanceDetailPageState();
}

class _AccountBalanceDetailPageState extends State<AccountBalanceDetailPage> {
  final Set<int> _expanded = {0}; // CHECK row expanded by default like the image
  bool _showCurrentDay = true; // current day selected by default (matches image)
  bool _isFilterOpen = false;

  static const _transactions = [
    TransactionEntry(
      type: 'CHECK',
      category: 'CREDIT',
      date: 'Jul 21, 2024',
      amount: '570.24',
      currency: 'ZAR',
      hasCheckImages: true,
    ),
    TransactionEntry(
      type: 'ACH',
      category: 'CREDIT',
      date: 'Jul 21, 2024',
      amount: '258.87',
      currency: 'ZAR',
    ),
    TransactionEntry(
      type: 'WIRES',
      category: 'CREDIT',
      date: 'Jul 21, 2024',
      amount: '63.50',
      currency: 'ZAR',
    ),
    TransactionEntry(
      type: 'LOCKBOX',
      category: 'CREDIT',
      date: 'Jul 24, 2024',
      amount: '89,447.58',
      currency: 'ZAR',
    ),
    TransactionEntry(
      type: 'ACH',
      category: 'CREDIT',
      date: 'Jul 25, 2024',
      amount: '570.24',
      currency: 'ZAR',
    ),
    TransactionEntry(
      type: 'WIRES',
      category: 'CREDIT',
      date: 'Jul 25, 2024',
      amount: '1,200.00',
      currency: 'ZAR',
    ),
    TransactionEntry(
      type: 'ACH',
      category: 'CREDIT',
      date: 'Jul 26, 2024',
      amount: '3,400.00',
      currency: 'ZAR',
    ),
    TransactionEntry(
      type: 'FED WIRE',
      category: 'CREDIT',
      date: 'Jul 28, 2024',
      amount: '125,000.00',
      currency: 'USD',
    ),
    TransactionEntry(
      type: 'BOOK TRANSFER',
      category: 'DEBIT',
      date: 'Jul 28, 2024',
      amount: '45,200.00',
      currency: 'USD',
    ),
    TransactionEntry(
      type: 'RTP',
      category: 'CREDIT',
      date: 'Jul 29, 2024',
      amount: '8,750.50',
      currency: 'USD',
    ),
    TransactionEntry(
      type: 'SWIFT',
      category: 'CREDIT',
      date: 'Jul 30, 2024',
      amount: '220,500.00',
      currency: 'EUR',
    ),
    TransactionEntry(
      type: 'RETURN',
      category: 'DEBIT',
      date: 'Jul 31, 2024',
      amount: '2,180.75',
      currency: 'USD',
    ),
    TransactionEntry(
      type: 'DEPOSIT',
      category: 'CREDIT',
      date: 'Aug 1, 2024',
      amount: '50,000.00',
      currency: 'USD',
    ),
    TransactionEntry(
      type: 'CHECK',
      category: 'CREDIT',
      date: 'Aug 2, 2024',
      amount: '14,322.10',
      currency: 'USD',
      hasCheckImages: true,
    ),
    TransactionEntry(
      type: 'ACH',
      category: 'DEBIT',
      date: 'Aug 2, 2024',
      amount: '9,600.00',
      currency: 'USD',
    ),
    TransactionEntry(
      type: 'LOCKBOX',
      category: 'CREDIT',
      date: 'Aug 3, 2024',
      amount: '307,841.22',
      currency: 'USD',
    ),
    TransactionEntry(
      type: 'WIRES',
      category: 'DEBIT',
      date: 'Aug 5, 2024',
      amount: '75,000.00',
      currency: 'JPY',
    ),
    TransactionEntry(
      type: 'FED WIRE',
      category: 'DEBIT',
      date: 'Aug 6, 2024',
      amount: '33,450.00',
      currency: 'USD',
    ),
  ];

  void _toggle(int i) {
    setState(() {
      if (_expanded.contains(i)) {
        _expanded.remove(i);
      } else {
        _expanded.add(i);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final acc = widget.account;
    final indexLabel = '${widget.accountIndex + 1} of ${widget.totalAccounts}';

    return Scaffold(
      backgroundColor: const Color(0xFFECEFF4),
      body: Column(
        children: [
          // 1 ── Dark header
          _AccountHeader(
            account: acc,
            indexLabel: indexLabel,
            onBack: () => Navigator.of(context).pop(),
          ),
          // 2 ── Previous / Current day balance bar
          _BalanceBar(
            prevBalance: acc.prevBalanceFormatted,
            currBalance: acc.currBalanceFormatted,
            showCurrentDay: _showCurrentDay,
            onToggle: (val) => setState(() => _showCurrentDay = val),
          ),
          // 3 & 4 ── Records, Stats + Transaction list (Wrapped in Stack for filter overlay)
          Expanded(
            child: Stack(
              children: [
                Column(
                  children: [
                    _RecordsAndStats(
                      currency: _showCurrentDay ? acc.currCurrency : acc.prevCurrency,
                      recordCount: _transactions.length,
                      showCurrentDay: _showCurrentDay,
                      isFilterOpen: _isFilterOpen,
                      onFilterTap: () => setState(() => _isFilterOpen = !_isFilterOpen),
                    ),
                    Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        itemCount: _transactions.length,
                        separatorBuilder: (_, __) =>
                            const Divider(height: 1, color: Color(0xFFD0D5DE)),
                        itemBuilder: (context, i) {
                          final tx = _transactions[i];
                          return _TxRow(
                            tx: tx,
                            expanded: _expanded.contains(i),
                            onToggle: () => _toggle(i),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                if (_isFilterOpen)
                  Positioned(
                    top: 56, // just below the "Showing N records" bar
                    left: 16,
                    right: 16,
                    bottom: 16, // prevent overflow
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: _FilterPanel(
                        onClose: () => setState(() => _isFilterOpen = false),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 1. Dark header
// ─────────────────────────────────────────────────────────────────────────────

class _AccountHeader extends StatelessWidget {
  const _AccountHeader({
    required this.account,
    required this.indexLabel,
    required this.onBack,
  });

  final AccountEntry account;
  final String indexLabel;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    // Truncate name to fit the "MUFG TB CHI B..." style
    final displayName = account.name.length > 35
        ? '${account.name.substring(0, 35)}...'
        : account.name;

    return Container(
      color: const Color(0xFF3C3C3E),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: account name
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.white, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    displayName,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Row 2: masked number | date + navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 4),
                  Text(
                    account.maskedNumber,
                    style: const TextStyle(color: Colors.white60, fontSize: 13),
                  ),
                  Text(
                    '  Sep 1, 2025',
                    style: const TextStyle(color: Colors.white60, fontSize: 13),
                  ),

                  Row(
                    children: [
                      const Icon(Icons.chevron_left, color: Colors.white, size: 22),
                      Text(
                        '($indexLabel)',
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      const SizedBox(width: 4),
                      // Dropdown button
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white54, width: 1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(Icons.keyboard_arrow_down,
                            color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 4),
                      // Next account chevron
                      const Icon(Icons.chevron_right, color: Colors.white, size: 22),
                    ],
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 2. Balance bar
// ─────────────────────────────────────────────────────────────────────────────

class _BalanceBar extends StatelessWidget {
  const _BalanceBar({
    required this.prevBalance,
    required this.currBalance,
    required this.showCurrentDay,
    required this.onToggle,
  });

  final String prevBalance;
  final String currBalance;
  final bool showCurrentDay;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    const activeColor = Color(0xFFC0392B);
    const inactiveBg = Color(0xFFEEEEEE);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Two-column balance row
        IntrinsicHeight(
          child: Row(
            children: [
              // ── Previous day
              Expanded(
                child: GestureDetector(
                  onTap: () => onToggle(false),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    color: !showCurrentDay ? activeColor : inactiveBg,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Previous day',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: !showCurrentDay
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: !showCurrentDay
                                ? Colors.white
                                : const Color(0xFF888888),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          prevBalance,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: !showCurrentDay
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: !showCurrentDay
                                ? Colors.white
                                : const Color(0xFF2C2C2C),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // ── Current day
              Expanded(
                child: GestureDetector(
                  onTap: () => onToggle(true),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    color: showCurrentDay ? activeColor : inactiveBg,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Current day',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: showCurrentDay
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: showCurrentDay
                                ? Colors.white
                                : const Color(0xFF888888),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          currBalance,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: showCurrentDay
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: showCurrentDay
                                ? Colors.white
                                : const Color(0xFF2C2C2C),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Callout triangle follows the active panel
        Row(
          children: [
            // Left slot
            Expanded(
              child: Container(
                height: 12,
                color: const Color(0xFFEEEEEE),
                child: !showCurrentDay
                    ? Center(
                        child: CustomPaint(
                          size: const Size(26, 12),
                          painter: _TrianglePainter(color: activeColor),
                        ),
                      )
                    : null,
              ),
            ),
            // Right slot
            Expanded(
              child: Container(
                height: 12,
                color: const Color(0xFFEEEEEE),
                child: showCurrentDay
                    ? Center(
                        child: CustomPaint(
                          size: const Size(26, 12),
                          painter: _TrianglePainter(color: activeColor),
                        ),
                      )
                    : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TrianglePainter extends CustomPainter {
  const _TrianglePainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      Path()
        ..moveTo(0, 0)
        ..lineTo(size.width / 2, size.height)
        ..lineTo(size.width, 0)
        ..close(),
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(_TrianglePainter old) => old.color != color;
}

// ─────────────────────────────────────────────────────────────────────────────
// 3. Records bar + Stats block (both white)
// ─────────────────────────────────────────────────────────────────────────────

class _RecordsAndStats extends StatelessWidget {
  const _RecordsAndStats({
    required this.currency,
    required this.recordCount,
    required this.showCurrentDay,
    required this.isFilterOpen,
    required this.onFilterTap,
  });

  final String currency;
  final int recordCount;
  final bool showCurrentDay;
  final bool isFilterOpen;
  final VoidCallback onFilterTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Records count row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
            child: Row(
              children: [
                Text(
                  'Showing $recordCount records',
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                ),
                const Spacer(),
                // Sort icon button
                _CircleIconButton(icon: Icons.sort, onTap: () {}),
                const SizedBox(width: 8),
                // Filter icon button
                _CircleIconButton(
                  icon: Icons.filter_alt_outlined, 
                  isActive: isFilterOpen,
                  onTap: onFilterTap,
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFD8D8D8)),
          // ── Stats rows
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StatRow(label: 'Number of Credits:', value: '75'),
                _StatRow(
                  label: 'Total Amount of Credits:',
                  value: '1,863,394.29 $currency',
                ),
                _StatRow(label: 'Number of Debits:', value: '0'),
                _StatRow(
                  label: 'Total Amount of Debits:',
                  value: '0.00 $currency',
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFD0D5DE)),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap, this.isActive = false});
  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF333333) : const Color(0xFFCCCCCC),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 22, color: isActive ? Colors.white : const Color(0xFF3C3C3E)),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fixed-width label column so values all align
          SizedBox(
            width: 210,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Filter Panel Overlay
// ─────────────────────────────────────────────────────────────────────────────

class _FilterPanel extends StatelessWidget {
  const _FilterPanel({required this.onClose});
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Little white arrow pointing up
        Padding(
          padding: const EdgeInsets.only(right: 6.0),
          child: CustomPaint(
            size: const Size(16, 8),
            painter: _UpTrianglePainter(color: Colors.white),
          ),
        ),
        // Filter card
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F7), // very light grey background matching image inner card background
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Transaction Type
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Transaction Type',
                              style: TextStyle(color: Color(0xFF8E8E93), fontSize: 13),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Select transaction type',
                              style: TextStyle(color: Color(0xFF8E8E93), fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(width: 1, height: 40, color: const Color(0xFFE5E5EA)),
                    const SizedBox(
                      width: 40,
                      child: Icon(Icons.keyboard_arrow_down, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              
              // 2. Date Range
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Date Range',
                      style: TextStyle(color: Color(0xFF8E8E93), fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildInput('From', Icons.calendar_today)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInput('To', Icons.calendar_today)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // 3. Amount Range
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Amount USD Range',
                      style: TextStyle(color: Color(0xFF8E8E93), fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFD8D8D8)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              child: Text('Min', style: TextStyle(color: Color(0xFF8E8E93), fontSize: 15)),
                            ),
                          ),
                          Container(width: 1, height: 30, color: const Color(0xFFD8D8D8)),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              child: Text('Max', style: TextStyle(color: Color(0xFF8E8E93), fontSize: 15)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Buttons
              Row(
                children: [
                  _buildBtn('Close', false, onClose),
                  const SizedBox(width: 8),
                  _buildBtn('Clear All', false, () {}),
                  const Spacer(),
                  _buildBtn('Apply', true, onClose),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInput(String hint, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD8D8D8)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(hint, style: const TextStyle(color: Color(0xFF8E8E93), fontSize: 15)),
          Icon(icon, size: 18, color: Colors.black87),
        ],
      ),
    );
  }

  Widget _buildBtn(String text, bool isDark, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF333333) : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: isDark ? null : Border.all(color: const Color(0xFFD8D8D8)),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _UpTrianglePainter extends CustomPainter {
  const _UpTrianglePainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      Path()
        ..moveTo(0, size.height)
        ..lineTo(size.width / 2, 0)
        ..lineTo(size.width, size.height)
        ..close(),
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(_UpTrianglePainter old) => old.color != color;
}

// ─────────────────────────────────────────────────────────────────────────────
// 4. Transaction row
// ─────────────────────────────────────────────────────────────────────────────

// Background colours as seen in IMG_9526.jpg
const _kRowBg = Color(0xFFECEFF4);         // collapsed: subtle grey-blue
const _kRowExpandedBg = Color(0xFFDFE6F2); // expanded: slightly deeper blue-grey

class _TxRow extends StatelessWidget {
  const _TxRow({
    required this.tx,
    required this.expanded,
    required this.onToggle,
  });

  final TransactionEntry tx;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: expanded ? _kRowExpandedBg : _kRowBg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Main tappable row
          InkWell(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 14, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type + category/date
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tx.type,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${tx.category} | ${tx.date}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF888888),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Amount + currency superscript + chevron (stacked)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Amount row: "+ 570.24 ZAR" where ZAR sits top-right
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '+ ${tx.amount}',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF27AE60),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 1),
                            child: Text(
                              tx.currency,
                              style: const TextStyle(
                                fontSize: 9,
                                color: Color(0xFF888888),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Animated chevron
                      AnimatedRotation(
                        turns: expanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 180),
                        child: const Icon(
                          Icons.keyboard_arrow_down,
                          size: 22,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // ── Expanded detail
          if (expanded) ...[
            if (tx.hasCheckImages)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                child: GestureDetector(
                  onTap: () {},
                  child: Text(
                    'View Check Images',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.blue[800],
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.blue[800],
                    ),
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DetailItem(label: 'Type', value: tx.type),
                    _DetailItem(label: 'Category', value: tx.category),
                    _DetailItem(label: 'Date', value: tx.date),
                    _DetailItem(
                        label: 'Amount', value: '+ ${tx.amount} ${tx.currency}'),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  const _DetailItem({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: Color(0xFF888888)),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
