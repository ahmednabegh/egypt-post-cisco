// // // import 'dart:convert';

// // // import 'package:flutter/material.dart';
// // // import 'package:flutter/services.dart';

// // // void main() {
// // //   WidgetsFlutterBinding.ensureInitialized();
// // //   runApp(const EgyptPostCiscoApp());
// // // }

// // // class EgyptPostCiscoApp extends StatelessWidget {
// // //   const EgyptPostCiscoApp({super.key});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     const seed = Color(0xFF07965F);
// // //     return MaterialApp(
// // //       debugShowCheckedModeBanner: false,
// // //       title: 'Egypt Post Cisco',
// // //       theme: ThemeData(
// // //         useMaterial3: true,
// // //         colorScheme: ColorScheme.fromSeed(
// // //           seedColor: seed,
// // //           primary: seed,
// // //           secondary: const Color(0xFF013F2B),
// // //           surface: const Color(0xFFF4FBF7),
// // //         ),
// // //         scaffoldBackgroundColor: const Color(0xFFF4FBF7),
// // //         fontFamily: 'Arial',
// // //         appBarTheme: const AppBarTheme(
// // //           centerTitle: true,
// // //           backgroundColor: Colors.transparent,
// // //           elevation: 0,
// // //           foregroundColor: Color(0xFF003D2A),
// // //         ),
// // //         inputDecorationTheme: InputDecorationTheme(
// // //           filled: true,
// // //           fillColor: Colors.white,
// // //           border: OutlineInputBorder(
// // //             borderRadius: BorderRadius.circular(22),
// // //             borderSide: BorderSide.none,
// // //           ),
// // //         ),
// // //       ),
// // //       home: const Directionality(
// // //         textDirection: TextDirection.rtl,
// // //         child: CiscoHomePage(),
// // //       ),
// // //     );
// // //   }
// // // }

// // // class CiscoEntry {
// // //   CiscoEntry({
// // //     required this.id,
// // //     required this.region,
// // //     required this.name,
// // //     required this.description,
// // //     required this.cisco,
// // //     required this.notes,
// // //   });

// // //   final int id;
// // //   final String region;
// // //   final String name;
// // //   final String description;
// // //   final String cisco;
// // //   final String notes;

// // //   factory CiscoEntry.fromJson(Map<String, dynamic> json) => CiscoEntry(
// // //         id: json['id'] as int,
// // //         region: json['region'] as String? ?? '',
// // //         name: json['name'] as String? ?? '',
// // //         description: json['description'] as String? ?? '',
// // //         cisco: json['cisco'] as String? ?? '',
// // //         notes: json['notes'] as String? ?? '',
// // //       );
// // // }

// // // class CiscoHomePage extends StatefulWidget {
// // //   const CiscoHomePage({super.key});

// // //   @override
// // //   State<CiscoHomePage> createState() => _CiscoHomePageState();
// // // }

// // // class _CiscoHomePageState extends State<CiscoHomePage> {
// // //   final TextEditingController _searchController = TextEditingController();
// // //   final FocusNode _searchFocus = FocusNode();

// // //   List<CiscoEntry> _all = const [];
// // //   List<CiscoEntry> _filtered = const [];
// // //   List<String> _regions = const [];
// // //   String _query = '';
// // //   String _selectedRegion = 'كل المناطق';
// // //   String _selectedType = 'الكل';
// // //   bool _loading = true;

// // //   static const List<String> _types = [
// // //     'الكل',
// // //     'مكاتب البريد',
// // //     'مناطق التوزيع',
// // //     'القطاعات',
// // //   ];

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _loadData();
// // //     _searchController.addListener(() {
// // //       _query = _searchController.text;
// // //       _applyFilters();
// // //     });
// // //   }

// // //   Future<void> _loadData() async {
// // //     final raw = await rootBundle.loadString('assets/data/cisco_directory.json');
// // //     final decoded = jsonDecode(raw) as List<dynamic>;
// // //     final loaded = decoded
// // //         .map((e) => CiscoEntry.fromJson(e as Map<String, dynamic>))
// // //         .toList(growable: false);
// // //     final regions = loaded.map((e) => e.region).toSet().toList()..sort();
// // //     setState(() {
// // //       _all = loaded;
// // //       _regions = ['كل المناطق', ...regions];
// // //       _loading = false;
// // //     });
// // //     _applyFilters();
// // //   }

// // //   String _normalize(String value) {
// // //     return value
// // //         .replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '')
// // //         .replaceAll('أ', 'ا')
// // //         .replaceAll('إ', 'ا')
// // //         .replaceAll('آ', 'ا')
// // //         .replaceAll('ى', 'ي')
// // //         .replaceAll('ة', 'ه')
// // //         .replaceAll('ؤ', 'و')
// // //         .replaceAll('ئ', 'ي')
// // //         .replaceAll(RegExp(r'\s+'), ' ')
// // //         .trim()
// // //         .toLowerCase();
// // //   }

// // //   bool _matchesType(CiscoEntry item) {
// // //     switch (_selectedType) {
// // //       case 'مكاتب البريد':
// // //         return item.description.contains('مكتب بريد');
// // //       case 'مناطق التوزيع':
// // //         return item.region.contains('مناطق التوزيع') ||
// // //             item.description.contains('توزيع');
// // //       case 'القطاعات':
// // //         return item.region.contains('القطاعات');
// // //       default:
// // //         return true;
// // //     }
// // //   }

// // //   void _applyFilters() {
// // //     if (_all.isEmpty) return;
// // //     final q = _normalize(_query);
// // //     final result = _all.where((item) {
// // //       final regionOk = _selectedRegion == 'كل المناطق' ||
// // //           item.region == _selectedRegion;
// // //       final typeOk = _matchesType(item);
// // //       if (!regionOk || !typeOk) return false;
// // //       if (q.isEmpty) return true;
// // //       final haystack = _normalize(
// // //         '${item.name} ${item.region} ${item.description} ${item.cisco} ${item.notes}',
// // //       );
// // //       return haystack.contains(q);
// // //     }).toList(growable: false);

// // //     setState(() => _filtered = result);
// // //   }

// // //   @override
// // //   void dispose() {
// // //     _searchController.dispose();
// // //     _searchFocus.dispose();
// // //     super.dispose();
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       body: _loading
// // //           ? const Center(child: CircularProgressIndicator())
// // //           : CustomScrollView(
// // //               slivers: [
// // //                 SliverToBoxAdapter(child: _HeroHeader(total: _all.length)),
// // //                 SliverPersistentHeader(
// // //                   pinned: true,
// // //                   delegate: _SearchHeaderDelegate(
// // //                     minHeight: 214,
// // //                     maxHeight: 214,
// // //                     child: _SearchPanel(
// // //                       controller: _searchController,
// // //                       focusNode: _searchFocus,
// // //                       regions: _regions,
// // //                       selectedRegion: _selectedRegion,
// // //                       selectedType: _selectedType,
// // //                       types: _types,
// // //                       resultCount: _filtered.length,
// // //                       onRegionChanged: (value) {
// // //                         setState(() => _selectedRegion = value ?? 'كل المناطق');
// // //                         _applyFilters();
// // //                       },
// // //                       onTypeChanged: (value) {
// // //                         setState(() => _selectedType = value);
// // //                         _applyFilters();
// // //                       },
// // //                       onClear: () {
// // //                         _searchController.clear();
// // //                         setState(() {
// // //                           _selectedRegion = 'كل المناطق';
// // //                           _selectedType = 'الكل';
// // //                         });
// // //                         _applyFilters();
// // //                       },
// // //                     ),
// // //                   ),
// // //                 ),
// // //                 if (_filtered.isEmpty)
// // //                   const SliverFillRemaining(
// // //                     hasScrollBody: false,
// // //                     child: _EmptyState(),
// // //                   )
// // //                 else
// // //                   SliverPadding(
// // //                     padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
// // //                     sliver: SliverList.separated(
// // //                       itemCount: _filtered.length,
// // //                       separatorBuilder: (_, __) => const SizedBox(height: 10),
// // //                       itemBuilder: (context, index) {
// // //                         final item = _filtered[index];
// // //                         return _ResultCard(
// // //                           entry: item,
// // //                           onTap: () => _showEntryDetails(item),
// // //                         );
// // //                       },
// // //                     ),
// // //                   ),
// // //               ],
// // //             ),
// // //     );
// // //   }

// // //   void _showEntryDetails(CiscoEntry entry) {
// // //     showModalBottomSheet<void>(
// // //       context: context,
// // //       showDragHandle: true,
// // //       isScrollControlled: true,
// // //       backgroundColor: Colors.white,
// // //       shape: const RoundedRectangleBorder(
// // //         borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
// // //       ),
// // //       builder: (context) => Directionality(
// // //         textDirection: TextDirection.rtl,
// // //         child: Padding(
// // //           padding: EdgeInsets.only(
// // //             left: 22,
// // //             right: 22,
// // //             top: 4,
// // //             bottom: MediaQuery.of(context).padding.bottom + 22,
// // //           ),
// // //           child: Column(
// // //             mainAxisSize: MainAxisSize.min,
// // //             crossAxisAlignment: CrossAxisAlignment.stretch,
// // //             children: [
// // //               Row(
// // //                 children: [
// // //                   const _LogoMark(size: 54),
// // //                   const SizedBox(width: 12),
// // //                   Expanded(
// // //                     child: Column(
// // //                       crossAxisAlignment: CrossAxisAlignment.start,
// // //                       children: [
// // //                         Text(
// // //                           entry.name,
// // //                           style: const TextStyle(
// // //                             fontSize: 22,
// // //                             fontWeight: FontWeight.w900,
// // //                             color: Color(0xFF003D2A),
// // //                           ),
// // //                         ),
// // //                         Text(
// // //                           entry.region,
// // //                           style: const TextStyle(
// // //                             color: Color(0xFF668075),
// // //                             fontWeight: FontWeight.w600,
// // //                           ),
// // //                         ),
// // //                       ],
// // //                     ),
// // //                   ),
// // //                 ],
// // //               ),
// // //               const SizedBox(height: 18),
// // //               _InfoTile(label: 'رقم السيسكو', value: entry.cisco, isNumber: true),
// // //               _InfoTile(label: 'الوصف / الوظيفة', value: entry.description),
// // //               if (entry.notes.trim().isNotEmpty)
// // //                 _InfoTile(label: 'ملاحظات', value: entry.notes),
// // //               const SizedBox(height: 14),
// // //               FilledButton.icon(
// // //                 onPressed: () {
// // //                   Clipboard.setData(ClipboardData(text: entry.cisco));
// // //                   Navigator.pop(context);
// // //                   ScaffoldMessenger.of(context).showSnackBar(
// // //                     SnackBar(
// // //                       content: Text('تم نسخ رقم السيسكو: ${entry.cisco}'),
// // //                       behavior: SnackBarBehavior.floating,
// // //                     ),
// // //                   );
// // //                 },
// // //                 icon: const Icon(Icons.copy_rounded),
// // //                 label: const Text('نسخ رقم السيسكو'),
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // // class _HeroHeader extends StatelessWidget {
// // //   const _HeroHeader({required this.total});

// // //   final int total;

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Container(
// // //       padding: EdgeInsets.only(
// // //         top: MediaQuery.of(context).padding.top + 22,
// // //         left: 18,
// // //         right: 18,
// // //         bottom: 22,
// // //       ),
// // //       decoration: const BoxDecoration(
// // //         gradient: LinearGradient(
// // //           begin: Alignment.topRight,
// // //           end: Alignment.bottomLeft,
// // //           colors: [Color(0xFF07965F), Color(0xFF006B48)],
// // //         ),
// // //         borderRadius: BorderRadius.vertical(bottom: Radius.circular(34)),
// // //       ),
// // //       child: Stack(
// // //         children: [
// // //           PositionedDirectional(
// // //             end: -45,
// // //             bottom: -55,
// // //             child: Opacity(
// // //               opacity: .12,
// // //               child: Image.asset(
// // //                 'assets/images/egypt_post_logo.png',
// // //                 width: 210,
// // //                 height: 210,
// // //               ),
// // //             ),
// // //           ),
// // //           Column(
// // //             crossAxisAlignment: CrossAxisAlignment.stretch,
// // //             children: [
// // //               Row(
// // //                 children: [
// // //                   const _LogoMark(size: 72),
// // //                   const SizedBox(width: 14),
// // //                   Expanded(
// // //                     child: Column(
// // //                       crossAxisAlignment: CrossAxisAlignment.start,
// // //                       children: [
// // //                         const Text(
// // //                           'Egypt Post Cisco',
// // //                           textDirection: TextDirection.ltr,
// // //                           style: TextStyle(
// // //                             color: Colors.white,
// // //                             fontSize: 24,
// // //                             fontWeight: FontWeight.w900,
// // //                             letterSpacing: .3,
// // //                           ),
// // //                         ),
// // //                         Text(
// // //                           'دليل أرقام السيسكو للبريد المصري',
// // //                           style: TextStyle(
// // //                             color: Colors.white.withOpacity(.86),
// // //                             fontSize: 14,
// // //                             fontWeight: FontWeight.w600,
// // //                           ),
// // //                         ),
// // //                       ],
// // //                     ),
// // //                   ),
// // //                 ],
// // //               ),
// // //               const SizedBox(height: 24),
// // //               Wrap(
// // //                 spacing: 10,
// // //                 runSpacing: 10,
// // //                 children: [
// // //                   _StatPill(
// // //                     icon: Icons.dialpad_rounded,
// // //                     label: 'رقم محفوظ',
// // //                     value: '$total+',
// // //                   ),
// // //                   const _StatPill(
// // //                     icon: Icons.public_rounded,
// // //                     label: 'بحث باسم أو مكان',
// // //                     value: 'ذكي',
// // //                   ),
// // //                   const _StatPill(
// // //                     icon: Icons.offline_bolt_rounded,
// // //                     label: 'بدون إنترنت',
// // //                     value: 'Offline',
// // //                   ),
// // //                 ],
// // //               ),
// // //             ],
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }

// // // class _SearchPanel extends StatelessWidget {
// // //   const _SearchPanel({
// // //     required this.controller,
// // //     required this.focusNode,
// // //     required this.regions,
// // //     required this.selectedRegion,
// // //     required this.selectedType,
// // //     required this.types,
// // //     required this.resultCount,
// // //     required this.onRegionChanged,
// // //     required this.onTypeChanged,
// // //     required this.onClear,
// // //   });

// // //   final TextEditingController controller;
// // //   final FocusNode focusNode;
// // //   final List<String> regions;
// // //   final String selectedRegion;
// // //   final String selectedType;
// // //   final List<String> types;
// // //   final int resultCount;
// // //   final ValueChanged<String?> onRegionChanged;
// // //   final ValueChanged<String> onTypeChanged;
// // //   final VoidCallback onClear;

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Material(
// // //       color: const Color(0xFFF4FBF7),
// // //       child: Padding(
// // //         padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
// // //         child: Column(
// // //           children: [
// // //             TextField(
// // //               controller: controller,
// // //               focusNode: focusNode,
// // //               textInputAction: TextInputAction.search,
// // //               decoration: InputDecoration(
// // //                 hintText: 'ابحث باسم المكتب، المكان، الوظيفة، أو رقم السيسكو...',
// // //                 prefixIcon: const Icon(Icons.search_rounded),
// // //                 suffixIcon: controller.text.isEmpty
// // //                     ? null
// // //                     : IconButton(
// // //                         tooltip: 'مسح البحث',
// // //                         onPressed: controller.clear,
// // //                         icon: const Icon(Icons.close_rounded),
// // //                       ),
// // //               ),
// // //             ),
// // //             const SizedBox(height: 10),
// // //             Row(
// // //               children: [
// // //                 Expanded(
// // //                   child: DropdownButtonFormField<String>(
// // //                     value: selectedRegion,
// // //                     isExpanded: true,
// // //                     items: regions
// // //                         .map(
// // //                           (region) => DropdownMenuItem(
// // //                             value: region,
// // //                             child: Text(
// // //                               region,
// // //                               maxLines: 1,
// // //                               overflow: TextOverflow.ellipsis,
// // //                             ),
// // //                           ),
// // //                         )
// // //                         .toList(),
// // //                     onChanged: onRegionChanged,
// // //                     decoration: const InputDecoration(
// // //                       prefixIcon: Icon(Icons.location_on_outlined),
// // //                       contentPadding: EdgeInsets.symmetric(horizontal: 12),
// // //                     ),
// // //                   ),
// // //                 ),
// // //                 const SizedBox(width: 10),
// // //                 IconButton.filledTonal(
// // //                   tooltip: 'إعادة ضبط الفلاتر',
// // //                   onPressed: onClear,
// // //                   icon: const Icon(Icons.refresh_rounded),
// // //                 ),
// // //               ],
// // //             ),
// // //             const SizedBox(height: 10),
// // //             SizedBox(
// // //               height: 42,
// // //               child: ListView.separated(
// // //                 scrollDirection: Axis.horizontal,
// // //                 itemBuilder: (context, index) {
// // //                   final type = types[index];
// // //                   final selected = selectedType == type;
// // //                   return ChoiceChip(
// // //                     selected: selected,
// // //                     label: Text(type),
// // //                     onSelected: (_) => onTypeChanged(type),
// // //                     selectedColor: const Color(0xFF07965F),
// // //                     labelStyle: TextStyle(
// // //                       color: selected ? Colors.white : const Color(0xFF003D2A),
// // //                       fontWeight: FontWeight.w800,
// // //                     ),
// // //                   );
// // //                 },
// // //                 separatorBuilder: (_, __) => const SizedBox(width: 8),
// // //                 itemCount: types.length,
// // //               ),
// // //             ),
// // //             const SizedBox(height: 6),
// // //             Row(
// // //               children: [
// // //                 const Icon(Icons.format_list_numbered_rtl_rounded,
// // //                     size: 18, color: Color(0xFF07965F)),
// // //                 const SizedBox(width: 6),
// // //                 Text(
// // //                   '$resultCount نتيجة',
// // //                   style: const TextStyle(
// // //                     color: Color(0xFF003D2A),
// // //                     fontWeight: FontWeight.w900,
// // //                   ),
// // //                 ),
// // //                 const Spacer(),
// // //                 const Text(
// // //                   'اضغط على أي نتيجة للتفاصيل',
// // //                   style: TextStyle(color: Color(0xFF70877E), fontSize: 12),
// // //                 ),
// // //               ],
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // // class _ResultCard extends StatelessWidget {
// // //   const _ResultCard({required this.entry, required this.onTap});

// // //   final CiscoEntry entry;
// // //   final VoidCallback onTap;

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return InkWell(
// // //       borderRadius: BorderRadius.circular(22),
// // //       onTap: onTap,
// // //       child: Ink(
// // //         decoration: BoxDecoration(
// // //           color: Colors.white,
// // //           borderRadius: BorderRadius.circular(22),
// // //           border: Border.all(color: const Color(0xFFE2F1EA)),
// // //           boxShadow: const [
// // //             BoxShadow(
// // //               color: Color(0x12006B48),
// // //               blurRadius: 18,
// // //               offset: Offset(0, 8),
// // //             ),
// // //           ],
// // //         ),
// // //         padding: const EdgeInsets.all(14),
// // //         child: Row(
// // //           children: [
// // //             Container(
// // //               width: 58,
// // //               height: 58,
// // //               decoration: BoxDecoration(
// // //                 color: const Color(0xFFE8F8F0),
// // //                 borderRadius: BorderRadius.circular(18),
// // //               ),
// // //               child: const Icon(Icons.local_post_office_rounded,
// // //                   color: Color(0xFF07965F), size: 30),
// // //             ),
// // //             const SizedBox(width: 12),
// // //             Expanded(
// // //               child: Column(
// // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // //                 children: [
// // //                   Text(
// // //                     entry.name,
// // //                     maxLines: 1,
// // //                     overflow: TextOverflow.ellipsis,
// // //                     style: const TextStyle(
// // //                       fontSize: 16,
// // //                       fontWeight: FontWeight.w900,
// // //                       color: Color(0xFF003D2A),
// // //                     ),
// // //                   ),
// // //                   const SizedBox(height: 4),
// // //                   Text(
// // //                     entry.region,
// // //                     maxLines: 1,
// // //                     overflow: TextOverflow.ellipsis,
// // //                     style: const TextStyle(
// // //                       color: Color(0xFF667D73),
// // //                       fontWeight: FontWeight.w600,
// // //                     ),
// // //                   ),
// // //                   if (entry.description.trim().isNotEmpty) ...[
// // //                     const SizedBox(height: 4),
// // //                     Text(
// // //                       entry.description,
// // //                       maxLines: 1,
// // //                       overflow: TextOverflow.ellipsis,
// // //                       style: const TextStyle(color: Color(0xFF8A9A93)),
// // //                     ),
// // //                   ],
// // //                 ],
// // //               ),
// // //             ),
// // //             const SizedBox(width: 10),
// // //             Column(
// // //               children: [
// // //                 const Text(
// // //                   'Cisco',
// // //                   textDirection: TextDirection.ltr,
// // //                   style: TextStyle(
// // //                     fontSize: 11,
// // //                     color: Color(0xFF8A9A93),
// // //                     fontWeight: FontWeight.bold,
// // //                   ),
// // //                 ),
// // //                 const SizedBox(height: 3),
// // //                 Container(
// // //                   padding:
// // //                       const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
// // //                   decoration: BoxDecoration(
// // //                     color: const Color(0xFF003D2A),
// // //                     borderRadius: BorderRadius.circular(14),
// // //                   ),
// // //                   child: Text(
// // //                     entry.cisco,
// // //                     textDirection: TextDirection.ltr,
// // //                     style: const TextStyle(
// // //                       color: Colors.white,
// // //                       fontWeight: FontWeight.w900,
// // //                       letterSpacing: .5,
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // // class _InfoTile extends StatelessWidget {
// // //   const _InfoTile({required this.label, required this.value, this.isNumber = false});

// // //   final String label;
// // //   final String value;
// // //   final bool isNumber;

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Container(
// // //       margin: const EdgeInsets.only(bottom: 10),
// // //       padding: const EdgeInsets.all(14),
// // //       decoration: BoxDecoration(
// // //         color: const Color(0xFFF4FBF7),
// // //         borderRadius: BorderRadius.circular(18),
// // //         border: Border.all(color: const Color(0xFFE2F1EA)),
// // //       ),
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           Text(
// // //             label,
// // //             style: const TextStyle(
// // //               color: Color(0xFF70877E),
// // //               fontWeight: FontWeight.bold,
// // //               fontSize: 12,
// // //             ),
// // //           ),
// // //           const SizedBox(height: 5),
// // //           Text(
// // //             value.isEmpty ? '-' : value,
// // //             textDirection: isNumber ? TextDirection.ltr : TextDirection.rtl,
// // //             style: TextStyle(
// // //               color: const Color(0xFF003D2A),
// // //               fontSize: isNumber ? 26 : 16,
// // //               fontWeight: FontWeight.w900,
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }

// // // class _LogoMark extends StatelessWidget {
// // //   const _LogoMark({required this.size});

// // //   final double size;

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Container(
// // //       width: size,
// // //       height: size,
// // //       padding: const EdgeInsets.all(5),
// // //       decoration: BoxDecoration(
// // //         color: Colors.white,
// // //         shape: BoxShape.circle,
// // //         boxShadow: [
// // //           BoxShadow(
// // //             color: Colors.black.withOpacity(.12),
// // //             blurRadius: 14,
// // //             offset: const Offset(0, 6),
// // //           ),
// // //         ],
// // //       ),
// // //       child: ClipOval(
// // //         child: Image.asset('assets/images/egypt_post_logo.png', fit: BoxFit.cover),
// // //       ),
// // //     );
// // //   }
// // // }

// // // class _StatPill extends StatelessWidget {
// // //   const _StatPill({
// // //     required this.icon,
// // //     required this.label,
// // //     required this.value,
// // //   });

// // //   final IconData icon;
// // //   final String label;
// // //   final String value;

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Container(
// // //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
// // //       decoration: BoxDecoration(
// // //         color: Colors.white.withOpacity(.16),
// // //         borderRadius: BorderRadius.circular(18),
// // //         border: Border.all(color: Colors.white.withOpacity(.22)),
// // //       ),
// // //       child: Row(
// // //         mainAxisSize: MainAxisSize.min,
// // //         children: [
// // //           Icon(icon, color: Colors.white, size: 20),
// // //           const SizedBox(width: 8),
// // //           Column(
// // //             crossAxisAlignment: CrossAxisAlignment.start,
// // //             children: [
// // //               Text(
// // //                 value,
// // //                 style: const TextStyle(
// // //                   color: Colors.white,
// // //                   fontWeight: FontWeight.w900,
// // //                   fontSize: 15,
// // //                 ),
// // //               ),
// // //               Text(
// // //                 label,
// // //                 style: TextStyle(
// // //                   color: Colors.white.withOpacity(.82),
// // //                   fontSize: 11,
// // //                   fontWeight: FontWeight.w600,
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }

// // // class _EmptyState extends StatelessWidget {
// // //   const _EmptyState();

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Center(
// // //       child: Padding(
// // //         padding: const EdgeInsets.all(28),
// // //         child: Column(
// // //           mainAxisSize: MainAxisSize.min,
// // //           children: [
// // //             Image.asset('assets/images/egypt_post_logo.png', width: 92, height: 92),
// // //             const SizedBox(height: 18),
// // //             const Text(
// // //               'لا توجد نتائج مطابقة',
// // //               style: TextStyle(
// // //                 fontSize: 20,
// // //                 fontWeight: FontWeight.w900,
// // //                 color: Color(0xFF003D2A),
// // //               ),
// // //             ),
// // //             const SizedBox(height: 8),
// // //             const Text(
// // //               'جرّب اسم أقصر، محافظة، وصف الوظيفة، أو رقم السيسكو مباشرة.',
// // //               textAlign: TextAlign.center,
// // //               style: TextStyle(color: Color(0xFF70877E)),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // // class _SearchHeaderDelegate extends SliverPersistentHeaderDelegate {
// // //   _SearchHeaderDelegate({
// // //     required this.child,
// // //     required this.minHeight,
// // //     required this.maxHeight,
// // //   });

// // //   final Widget child;
// // //   final double minHeight;
// // //   final double maxHeight;

// // //   @override
// // //   double get minExtent => minHeight;

// // //   @override
// // //   double get maxExtent => maxHeight;

// // //   @override
// // //   Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
// // //     return child;
// // //   }

// // //   @override
// // //   bool shouldRebuild(covariant _SearchHeaderDelegate oldDelegate) {
// // //     return oldDelegate.child != child ||
// // //         oldDelegate.minHeight != minHeight ||
// // //         oldDelegate.maxHeight != maxHeight;
// // //   }
// // // }
// // import 'dart:convert';

// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';

// // void main() {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   runApp(const EgyptPostCiscoApp());
// // }

// // class EgyptPostCiscoApp extends StatelessWidget {
// //   const EgyptPostCiscoApp({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     const seed = Color(0xFF07965F);

// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       title: 'Egypt Post Cisco',
// //       theme: ThemeData(
// //         useMaterial3: true,
// //         colorScheme: ColorScheme.fromSeed(
// //           seedColor: seed,
// //           primary: seed,
// //           secondary: const Color(0xFF013F2B),
// //           surface: const Color(0xFFF4FBF7),
// //         ),
// //         scaffoldBackgroundColor: const Color(0xFFF4FBF7),
// //         fontFamily: 'Arial',
// //         appBarTheme: const AppBarTheme(
// //           centerTitle: true,
// //           backgroundColor: Colors.transparent,
// //           elevation: 0,
// //           foregroundColor: Color(0xFF003D2A),
// //         ),
// //         inputDecorationTheme: InputDecorationTheme(
// //           filled: true,
// //           fillColor: Colors.white,
// //           border: OutlineInputBorder(
// //             borderRadius: BorderRadius.circular(22),
// //             borderSide: BorderSide.none,
// //           ),
// //         ),
// //       ),
// //       home: const Directionality(
// //         textDirection: TextDirection.rtl,
// //         child: SplashScreen(),
// //       ),
// //     );
// //   }
// // }

// // class SplashScreen extends StatefulWidget {
// //   const SplashScreen({super.key});

// //   @override
// //   State<SplashScreen> createState() => _SplashScreenState();
// // }

// // class _SplashScreenState extends State<SplashScreen>
// //     with SingleTickerProviderStateMixin {
// //   late final AnimationController _controller;
// //   late final Animation<double> _fadeAnimation;
// //   late final Animation<double> _scaleAnimation;
// //   late final Animation<Offset> _slideAnimation;

// //   @override
// //   void initState() {
// //     super.initState();

// //     _controller = AnimationController(
// //       vsync: this,
// //       duration: const Duration(milliseconds: 1800),
// //     );

// //     _fadeAnimation = CurvedAnimation(
// //       parent: _controller,
// //       curve: Curves.easeOut,
// //     );

// //     _scaleAnimation = Tween<double>(
// //       begin: .82,
// //       end: 1,
// //     ).animate(
// //       CurvedAnimation(
// //         parent: _controller,
// //         curve: Curves.easeOutBack,
// //       ),
// //     );

// //     _slideAnimation = Tween<Offset>(
// //       begin: const Offset(0, .18),
// //       end: Offset.zero,
// //     ).animate(
// //       CurvedAnimation(
// //         parent: _controller,
// //         curve: Curves.easeOutCubic,
// //       ),
// //     );

// //     _controller.forward();

// //     Future.delayed(const Duration(seconds: 4), () {
// //       if (!mounted) return;

// //       Navigator.of(context).pushReplacement(
// //         PageRouteBuilder(
// //           transitionDuration: const Duration(milliseconds: 850),
// //           pageBuilder: (_, animation, __) {
// //             return FadeTransition(
// //               opacity: animation,
// //               child: const Directionality(
// //                 textDirection: TextDirection.rtl,
// //                 child: CiscoHomePage(),
// //               ),
// //             );
// //           },
// //         ),
// //       );
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     _controller.dispose();
// //     super.dispose();
// //   }

// //   Widget _backgroundLogo({
// //     required double size,
// //     required double opacity,
// //   }) {
// //     return Opacity(
// //       opacity: opacity,
// //       child: Image.asset(
// //         'assets/images/egypt_post_logo.png',
// //         width: size,
// //         height: size,
// //         fit: BoxFit.cover,
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: AnnotatedRegion<SystemUiOverlayStyle>(
// //         value: SystemUiOverlayStyle.light,
// //         child: Container(
// //           width: double.infinity,
// //           height: double.infinity,
// //           decoration: const BoxDecoration(
// //             gradient: LinearGradient(
// //               begin: Alignment.topRight,
// //               end: Alignment.bottomLeft,
// //               colors: [
// //                 Color(0xFF07965F),
// //                 Color(0xFF006B48),
// //                 Color(0xFF003D2A),
// //               ],
// //             ),
// //           ),
// //           child: Stack(
// //             children: [
// //               PositionedDirectional(
// //                 top: -95,
// //                 end: -75,
// //                 child: _backgroundLogo(size: 285, opacity: .09),
// //               ),
// //               PositionedDirectional(
// //                 bottom: -110,
// //                 start: -90,
// //                 child: _backgroundLogo(size: 320, opacity: .075),
// //               ),
// //               PositionedDirectional(
// //                 top: MediaQuery.of(context).padding.top + 34,
// //                 start: 26,
// //                 child: Container(
// //                   padding: const EdgeInsets.symmetric(
// //                     horizontal: 14,
// //                     vertical: 8,
// //                   ),
// //                   decoration: BoxDecoration(
// //                     color: Colors.white.withOpacity(.13),
// //                     borderRadius: BorderRadius.circular(100),
// //                     border: Border.all(
// //                       color: Colors.white.withOpacity(.22),
// //                     ),
// //                   ),
// //                   child: const Row(
// //                     mainAxisSize: MainAxisSize.min,
// //                     children: [
// //                       Icon(
// //                         Icons.security_rounded,
// //                         color: Colors.white,
// //                         size: 18,
// //                       ),
// //                       SizedBox(width: 7),
// //                       Text(
// //                         'منطقة برج العرب',
// //                         style: TextStyle(
// //                           color: Colors.white,
// //                           fontWeight: FontWeight.w800,
// //                           fontSize: 13,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //               Center(
// //                 child: FadeTransition(
// //                   opacity: _fadeAnimation,
// //                   child: SlideTransition(
// //                     position: _slideAnimation,
// //                     child: ScaleTransition(
// //                       scale: _scaleAnimation,
// //                       child: Padding(
// //                         padding: const EdgeInsets.symmetric(horizontal: 26),
// //                         child: Column(
// //                           mainAxisSize: MainAxisSize.min,
// //                           children: [
// //                             Container(
// //                               width: 144,
// //                               height: 144,
// //                               padding: const EdgeInsets.all(8),
// //                               decoration: BoxDecoration(
// //                                 color: Colors.white,
// //                                 shape: BoxShape.circle,
// //                                 boxShadow: [
// //                                   BoxShadow(
// //                                     color: Colors.black.withOpacity(.25),
// //                                     blurRadius: 32,
// //                                     offset: const Offset(0, 16),
// //                                   ),
// //                                 ],
// //                               ),
// //                               child: ClipOval(
// //                                 child: Image.asset(
// //                                   'assets/images/egypt_post_logo.png',
// //                                   fit: BoxFit.cover,
// //                                 ),
// //                               ),
// //                             ),
// //                             const SizedBox(height: 28),
// //                             const Text(
// //                               'Egypt Post Cisco',
// //                               textDirection: TextDirection.ltr,
// //                               textAlign: TextAlign.center,
// //                               style: TextStyle(
// //                                 color: Colors.white,
// //                                 fontSize: 31,
// //                                 fontWeight: FontWeight.w900,
// //                                 letterSpacing: .4,
// //                               ),
// //                             ),
// //                             const SizedBox(height: 9),
// //                             Text(
// //                               'دليل أرقام السيسكو للبريد المصري',
// //                               textAlign: TextAlign.center,
// //                               style: TextStyle(
// //                                 color: Colors.white.withOpacity(.88),
// //                                 fontSize: 15,
// //                                 fontWeight: FontWeight.w700,
// //                               ),
// //                             ),
// //                             const SizedBox(height: 34),
// //                             Container(
// //                               width: double.infinity,
// //                               padding: const EdgeInsets.symmetric(
// //                                 horizontal: 20,
// //                                 vertical: 23,
// //                               ),
// //                               decoration: BoxDecoration(
// //                                 color: Colors.white.withOpacity(.14),
// //                                 borderRadius: BorderRadius.circular(28),
// //                                 border: Border.all(
// //                                   color: Colors.white.withOpacity(.24),
// //                                 ),
// //                                 boxShadow: [
// //                                   BoxShadow(
// //                                     color: Colors.black.withOpacity(.10),
// //                                     blurRadius: 24,
// //                                     offset: const Offset(0, 12),
// //                                   ),
// //                                 ],
// //                               ),
// //                               child: Column(
// //                                 children: [
// //                                   Container(
// //                                     width: 48,
// //                                     height: 5,
// //                                     decoration: BoxDecoration(
// //                                       color: Colors.white.withOpacity(.55),
// //                                       borderRadius: BorderRadius.circular(100),
// //                                     ),
// //                                   ),
// //                                   const SizedBox(height: 18),
// //                                   const Text(
// //                                     'هدية من إدارة التكنولوجيا والمعلومات\nبمنطقة برج العرب\nإلى جميع موظفي البريد المصري',
// //                                     textAlign: TextAlign.center,
// //                                     style: TextStyle(
// //                                       color: Colors.white,
// //                                       fontSize: 18,
// //                                       height: 1.7,
// //                                       fontWeight: FontWeight.w900,
// //                                     ),
// //                                   ),
// //                                 ],
// //                               ),
// //                             ),
// //                             const SizedBox(height: 34),
// //                             SizedBox(
// //                               width: 36,
// //                               height: 36,
// //                               child: CircularProgressIndicator(
// //                                 strokeWidth: 3,
// //                                 valueColor: const AlwaysStoppedAnimation<Color>(
// //                                   Colors.white,
// //                                 ),
// //                                 backgroundColor: Colors.white.withOpacity(.22),
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //               PositionedDirectional(
// //                 bottom: MediaQuery.of(context).padding.bottom + 28,
// //                 start: 24,
// //                 end: 24,
// //                 child: Text(
// //                   'Powered by Egypt Post Technology & Information',
// //                   textDirection: TextDirection.ltr,
// //                   textAlign: TextAlign.center,
// //                   style: TextStyle(
// //                     color: Colors.white.withOpacity(.62),
// //                     fontSize: 12,
// //                     fontWeight: FontWeight.w600,
// //                     letterSpacing: .2,
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class CiscoEntry {
// //   CiscoEntry({
// //     required this.id,
// //     required this.region,
// //     required this.name,
// //     required this.description,
// //     required this.cisco,
// //     required this.notes,
// //   });

// //   final int id;
// //   final String region;
// //   final String name;
// //   final String description;
// //   final String cisco;
// //   final String notes;

// //   factory CiscoEntry.fromJson(Map<String, dynamic> json) => CiscoEntry(
// //         id: json['id'] as int,
// //         region: json['region'] as String? ?? '',
// //         name: json['name'] as String? ?? '',
// //         description: json['description'] as String? ?? '',
// //         cisco: json['cisco'] as String? ?? '',
// //         notes: json['notes'] as String? ?? '',
// //       );
// // }

// // class CiscoHomePage extends StatefulWidget {
// //   const CiscoHomePage({super.key});

// //   @override
// //   State<CiscoHomePage> createState() => _CiscoHomePageState();
// // }

// // class _CiscoHomePageState extends State<CiscoHomePage> {
// //   final TextEditingController _searchController = TextEditingController();
// //   final FocusNode _searchFocus = FocusNode();

// //   List<CiscoEntry> _all = const [];
// //   List<CiscoEntry> _filtered = const [];
// //   List<String> _regions = const [];
// //   String _query = '';
// //   String _selectedRegion = 'كل المناطق';
// //   String _selectedType = 'الكل';
// //   bool _loading = true;

// //   static const List<String> _types = [
// //     'الكل',
// //     'مكاتب البريد',
// //     'مناطق التوزيع',
// //     'القطاعات',
// //   ];

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadData();
// //     _searchController.addListener(() {
// //       _query = _searchController.text;
// //       _applyFilters();
// //     });
// //   }

// //   Future<void> _loadData() async {
// //     final raw = await rootBundle.loadString('assets/data/cisco_directory.json');
// //     final decoded = jsonDecode(raw) as List<dynamic>;
// //     final loaded = decoded
// //         .map((e) => CiscoEntry.fromJson(e as Map<String, dynamic>))
// //         .toList(growable: false);

// //     final regions = loaded.map((e) => e.region).toSet().toList()..sort();

// //     setState(() {
// //       _all = loaded;
// //       _regions = ['كل المناطق', ...regions];
// //       _loading = false;
// //     });

// //     _applyFilters();
// //   }

// //   String _normalize(String value) {
// //     return value
// //         .replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '')
// //         .replaceAll('أ', 'ا')
// //         .replaceAll('إ', 'ا')
// //         .replaceAll('آ', 'ا')
// //         .replaceAll('ى', 'ي')
// //         .replaceAll('ة', 'ه')
// //         .replaceAll('ؤ', 'و')
// //         .replaceAll('ئ', 'ي')
// //         .replaceAll(RegExp(r'\s+'), ' ')
// //         .trim()
// //         .toLowerCase();
// //   }

// //   bool _matchesType(CiscoEntry item) {
// //     switch (_selectedType) {
// //       case 'مكاتب البريد':
// //         return item.description.contains('مكتب بريد');
// //       case 'مناطق التوزيع':
// //         return item.region.contains('مناطق التوزيع') ||
// //             item.description.contains('توزيع');
// //       case 'القطاعات':
// //         return item.region.contains('القطاعات');
// //       default:
// //         return true;
// //     }
// //   }

// //   void _applyFilters() {
// //     if (_all.isEmpty) return;

// //     final q = _normalize(_query);

// //     final result = _all.where((item) {
// //       final regionOk =
// //           _selectedRegion == 'كل المناطق' || item.region == _selectedRegion;
// //       final typeOk = _matchesType(item);

// //       if (!regionOk || !typeOk) return false;
// //       if (q.isEmpty) return true;

// //       final haystack = _normalize(
// //         '${item.name} ${item.region} ${item.description} ${item.cisco} ${item.notes}',
// //       );

// //       return haystack.contains(q);
// //     }).toList(growable: false);

// //     setState(() => _filtered = result);
// //   }

// //   @override
// //   void dispose() {
// //     _searchController.dispose();
// //     _searchFocus.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: _loading
// //           ? const Center(child: CircularProgressIndicator())
// //           : CustomScrollView(
// //               slivers: [
// //                 SliverToBoxAdapter(child: _HeroHeader(total: _all.length)),
// //                 SliverPersistentHeader(
// //                   pinned: true,
// //                   delegate: _SearchHeaderDelegate(
// //                     minHeight: 214,
// //                     maxHeight: 214,
// //                     child: _SearchPanel(
// //                       controller: _searchController,
// //                       focusNode: _searchFocus,
// //                       regions: _regions,
// //                       selectedRegion: _selectedRegion,
// //                       selectedType: _selectedType,
// //                       types: _types,
// //                       resultCount: _filtered.length,
// //                       onRegionChanged: (value) {
// //                         setState(() {
// //                           _selectedRegion = value ?? 'كل المناطق';
// //                         });
// //                         _applyFilters();
// //                       },
// //                       onTypeChanged: (value) {
// //                         setState(() {
// //                           _selectedType = value;
// //                         });
// //                         _applyFilters();
// //                       },
// //                       onClear: () {
// //                         _searchController.clear();
// //                         setState(() {
// //                           _selectedRegion = 'كل المناطق';
// //                           _selectedType = 'الكل';
// //                         });
// //                         _applyFilters();
// //                       },
// //                     ),
// //                   ),
// //                 ),
// //                 if (_filtered.isEmpty)
// //                   const SliverFillRemaining(
// //                     hasScrollBody: false,
// //                     child: _EmptyState(),
// //                   )
// //                 else
// //                   SliverPadding(
// //                     padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
// //                     sliver: SliverList.separated(
// //                       itemCount: _filtered.length,
// //                       separatorBuilder: (_, __) => const SizedBox(height: 10),
// //                       itemBuilder: (context, index) {
// //                         final item = _filtered[index];
// //                         return _ResultCard(
// //                           entry: item,
// //                           onTap: () => _showEntryDetails(item),
// //                         );
// //                       },
// //                     ),
// //                   ),
// //               ],
// //             ),
// //     );
// //   }

// //   void _showEntryDetails(CiscoEntry entry) {
// //     showModalBottomSheet<void>(
// //       context: context,
// //       showDragHandle: true,
// //       isScrollControlled: true,
// //       backgroundColor: Colors.white,
// //       shape: const RoundedRectangleBorder(
// //         borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
// //       ),
// //       builder: (context) => Directionality(
// //         textDirection: TextDirection.rtl,
// //         child: Padding(
// //           padding: EdgeInsets.only(
// //             left: 22,
// //             right: 22,
// //             top: 4,
// //             bottom: MediaQuery.of(context).padding.bottom + 22,
// //           ),
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             crossAxisAlignment: CrossAxisAlignment.stretch,
// //             children: [
// //               Row(
// //                 children: [
// //                   const _LogoMark(size: 54),
// //                   const SizedBox(width: 12),
// //                   Expanded(
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         Text(
// //                           entry.name,
// //                           style: const TextStyle(
// //                             fontSize: 22,
// //                             fontWeight: FontWeight.w900,
// //                             color: Color(0xFF003D2A),
// //                           ),
// //                         ),
// //                         Text(
// //                           entry.region,
// //                           style: const TextStyle(
// //                             color: Color(0xFF668075),
// //                             fontWeight: FontWeight.w600,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //               const SizedBox(height: 18),
// //               _InfoTile(
// //                 label: 'رقم السيسكو',
// //                 value: entry.cisco,
// //                 isNumber: true,
// //               ),
// //               _InfoTile(
// //                 label: 'الوصف / الوظيفة',
// //                 value: entry.description,
// //               ),
// //               if (entry.notes.trim().isNotEmpty)
// //                 _InfoTile(
// //                   label: 'ملاحظات',
// //                   value: entry.notes,
// //                 ),
// //               const SizedBox(height: 14),
// //               FilledButton.icon(
// //                 onPressed: () {
// //                   Clipboard.setData(ClipboardData(text: entry.cisco));
// //                   Navigator.pop(context);
// //                   ScaffoldMessenger.of(context).showSnackBar(
// //                     SnackBar(
// //                       content: Text('تم نسخ رقم السيسكو: ${entry.cisco}'),
// //                       behavior: SnackBarBehavior.floating,
// //                     ),
// //                   );
// //                 },
// //                 icon: const Icon(Icons.copy_rounded),
// //                 label: const Text('نسخ رقم السيسكو'),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class _HeroHeader extends StatelessWidget {
// //   const _HeroHeader({required this.total});

// //   final int total;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       padding: EdgeInsets.only(
// //         top: MediaQuery.of(context).padding.top + 22,
// //         left: 18,
// //         right: 18,
// //         bottom: 22,
// //       ),
// //       decoration: const BoxDecoration(
// //         gradient: LinearGradient(
// //           begin: Alignment.topRight,
// //           end: Alignment.bottomLeft,
// //           colors: [
// //             Color(0xFF07965F),
// //             Color(0xFF006B48),
// //           ],
// //         ),
// //         borderRadius: BorderRadius.vertical(bottom: Radius.circular(34)),
// //       ),
// //       child: Stack(
// //         children: [
// //           PositionedDirectional(
// //             end: -45,
// //             bottom: -55,
// //             child: Opacity(
// //               opacity: .12,
// //               child: Image.asset(
// //                 'assets/images/egypt_post_logo.png',
// //                 width: 210,
// //                 height: 210,
// //               ),
// //             ),
// //           ),
// //           Column(
// //             crossAxisAlignment: CrossAxisAlignment.stretch,
// //             children: [
// //               Row(
// //                 children: [
// //                   const _LogoMark(size: 72),
// //                   const SizedBox(width: 14),
// //                   Expanded(
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         const Text(
// //                           'Egypt Post Cisco',
// //                           textDirection: TextDirection.ltr,
// //                           style: TextStyle(
// //                             color: Colors.white,
// //                             fontSize: 24,
// //                             fontWeight: FontWeight.w900,
// //                             letterSpacing: .3,
// //                           ),
// //                         ),
// //                         Text(
// //                           'دليل أرقام السيسكو للبريد المصري',
// //                           style: TextStyle(
// //                             color: Colors.white.withOpacity(.86),
// //                             fontSize: 14,
// //                             fontWeight: FontWeight.w600,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //               const SizedBox(height: 24),
// //               Wrap(
// //                 spacing: 10,
// //                 runSpacing: 10,
// //                 children: [
// //                   _StatPill(
// //                     icon: Icons.dialpad_rounded,
// //                     label: 'رقم محفوظ',
// //                     value: '$total+',
// //                   ),
// //                   const _StatPill(
// //                     icon: Icons.public_rounded,
// //                     label: 'بحث باسم أو مكان',
// //                     value: 'ذكي',
// //                   ),
// //                   const _StatPill(
// //                     icon: Icons.offline_bolt_rounded,
// //                     label: 'بدون إنترنت',
// //                     value: 'Offline',
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class _SearchPanel extends StatelessWidget {
// //   const _SearchPanel({
// //     required this.controller,
// //     required this.focusNode,
// //     required this.regions,
// //     required this.selectedRegion,
// //     required this.selectedType,
// //     required this.types,
// //     required this.resultCount,
// //     required this.onRegionChanged,
// //     required this.onTypeChanged,
// //     required this.onClear,
// //   });

// //   final TextEditingController controller;
// //   final FocusNode focusNode;
// //   final List<String> regions;
// //   final String selectedRegion;
// //   final String selectedType;
// //   final List<String> types;
// //   final int resultCount;
// //   final ValueChanged<String?> onRegionChanged;
// //   final ValueChanged<String> onTypeChanged;
// //   final VoidCallback onClear;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Material(
// //       color: const Color(0xFFF4FBF7),
// //       child: Padding(
// //         padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
// //         child: Column(
// //           children: [
// //             TextField(
// //               controller: controller,
// //               focusNode: focusNode,
// //               textInputAction: TextInputAction.search,
// //               decoration: InputDecoration(
// //                 hintText:
// //                     'ابحث باسم المكتب، المكان، الوظيفة، أو رقم السيسكو...',
// //                 prefixIcon: const Icon(Icons.search_rounded),
// //                 suffixIcon: controller.text.isEmpty
// //                     ? null
// //                     : IconButton(
// //                         tooltip: 'مسح البحث',
// //                         onPressed: controller.clear,
// //                         icon: const Icon(Icons.close_rounded),
// //                       ),
// //               ),
// //             ),
// //             const SizedBox(height: 10),
// //             Row(
// //               children: [
// //                 Expanded(
// //                   child: DropdownButtonFormField<String>(
// //                     value: selectedRegion,
// //                     isExpanded: true,
// //                     items: regions
// //                         .map(
// //                           (region) => DropdownMenuItem(
// //                             value: region,
// //                             child: Text(
// //                               region,
// //                               maxLines: 1,
// //                               overflow: TextOverflow.ellipsis,
// //                             ),
// //                           ),
// //                         )
// //                         .toList(),
// //                     onChanged: onRegionChanged,
// //                     decoration: const InputDecoration(
// //                       prefixIcon: Icon(Icons.location_on_outlined),
// //                       contentPadding: EdgeInsets.symmetric(horizontal: 12),
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(width: 10),
// //                 IconButton.filledTonal(
// //                   tooltip: 'إعادة ضبط الفلاتر',
// //                   onPressed: onClear,
// //                   icon: const Icon(Icons.refresh_rounded),
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 10),
// //             SizedBox(
// //               height: 42,
// //               child: ListView.separated(
// //                 scrollDirection: Axis.horizontal,
// //                 itemBuilder: (context, index) {
// //                   final type = types[index];
// //                   final selected = selectedType == type;

// //                   return ChoiceChip(
// //                     selected: selected,
// //                     label: Text(type),
// //                     onSelected: (_) => onTypeChanged(type),
// //                     selectedColor: const Color(0xFF07965F),
// //                     labelStyle: TextStyle(
// //                       color: selected ? Colors.white : const Color(0xFF003D2A),
// //                       fontWeight: FontWeight.w800,
// //                     ),
// //                   );
// //                 },
// //                 separatorBuilder: (_, __) => const SizedBox(width: 8),
// //                 itemCount: types.length,
// //               ),
// //             ),
// //             const SizedBox(height: 6),
// //             Row(
// //               children: [
// //                 const Icon(
// //                   Icons.format_list_numbered_rtl_rounded,
// //                   size: 18,
// //                   color: Color(0xFF07965F),
// //                 ),
// //                 const SizedBox(width: 6),
// //                 Text(
// //                   '$resultCount نتيجة',
// //                   style: const TextStyle(
// //                     color: Color(0xFF003D2A),
// //                     fontWeight: FontWeight.w900,
// //                   ),
// //                 ),
// //                 const Spacer(),
// //                 const Text(
// //                   'اضغط على أي نتيجة للتفاصيل',
// //                   style: TextStyle(
// //                     color: Color(0xFF70877E),
// //                     fontSize: 12,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class _ResultCard extends StatelessWidget {
// //   const _ResultCard({
// //     required this.entry,
// //     required this.onTap,
// //   });

// //   final CiscoEntry entry;
// //   final VoidCallback onTap;

// //   @override
// //   Widget build(BuildContext context) {
// //     return InkWell(
// //       borderRadius: BorderRadius.circular(22),
// //       onTap: onTap,
// //       child: Ink(
// //         decoration: BoxDecoration(
// //           color: Colors.white,
// //           borderRadius: BorderRadius.circular(22),
// //           border: Border.all(color: const Color(0xFFE2F1EA)),
// //           boxShadow: const [
// //             BoxShadow(
// //               color: Color(0x12006B48),
// //               blurRadius: 18,
// //               offset: Offset(0, 8),
// //             ),
// //           ],
// //         ),
// //         padding: const EdgeInsets.all(14),
// //         child: Row(
// //           children: [
// //             Container(
// //               width: 58,
// //               height: 58,
// //               decoration: BoxDecoration(
// //                 color: const Color(0xFFE8F8F0),
// //                 borderRadius: BorderRadius.circular(18),
// //               ),
// //               child: const Icon(
// //                 Icons.local_post_office_rounded,
// //                 color: Color(0xFF07965F),
// //                 size: 30,
// //               ),
// //             ),
// //             const SizedBox(width: 12),
// //             Expanded(
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(
// //                     entry.name,
// //                     maxLines: 1,
// //                     overflow: TextOverflow.ellipsis,
// //                     style: const TextStyle(
// //                       fontSize: 16,
// //                       fontWeight: FontWeight.w900,
// //                       color: Color(0xFF003D2A),
// //                     ),
// //                   ),
// //                   const SizedBox(height: 4),
// //                   Text(
// //                     entry.region,
// //                     maxLines: 1,
// //                     overflow: TextOverflow.ellipsis,
// //                     style: const TextStyle(
// //                       color: Color(0xFF667D73),
// //                       fontWeight: FontWeight.w600,
// //                     ),
// //                   ),
// //                   if (entry.description.trim().isNotEmpty) ...[
// //                     const SizedBox(height: 4),
// //                     Text(
// //                       entry.description,
// //                       maxLines: 1,
// //                       overflow: TextOverflow.ellipsis,
// //                       style: const TextStyle(
// //                         color: Color(0xFF8A9A93),
// //                       ),
// //                     ),
// //                   ],
// //                 ],
// //               ),
// //             ),
// //             const SizedBox(width: 10),
// //             Column(
// //               children: [
// //                 const Text(
// //                   'Cisco',
// //                   textDirection: TextDirection.ltr,
// //                   style: TextStyle(
// //                     fontSize: 11,
// //                     color: Color(0xFF8A9A93),
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 3),
// //                 Container(
// //                   padding: const EdgeInsets.symmetric(
// //                     horizontal: 10,
// //                     vertical: 7,
// //                   ),
// //                   decoration: BoxDecoration(
// //                     color: const Color(0xFF003D2A),
// //                     borderRadius: BorderRadius.circular(14),
// //                   ),
// //                   child: Text(
// //                     entry.cisco,
// //                     textDirection: TextDirection.ltr,
// //                     style: const TextStyle(
// //                       color: Colors.white,
// //                       fontWeight: FontWeight.w900,
// //                       letterSpacing: .5,
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class _InfoTile extends StatelessWidget {
// //   const _InfoTile({
// //     required this.label,
// //     required this.value,
// //     this.isNumber = false,
// //   });

// //   final String label;
// //   final String value;
// //   final bool isNumber;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       margin: const EdgeInsets.only(bottom: 10),
// //       padding: const EdgeInsets.all(14),
// //       decoration: BoxDecoration(
// //         color: const Color(0xFFF4FBF7),
// //         borderRadius: BorderRadius.circular(18),
// //         border: Border.all(color: const Color(0xFFE2F1EA)),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text(
// //             label,
// //             style: const TextStyle(
// //               color: Color(0xFF70877E),
// //               fontWeight: FontWeight.bold,
// //               fontSize: 12,
// //             ),
// //           ),
// //           const SizedBox(height: 5),
// //           Text(
// //             value.isEmpty ? '-' : value,
// //             textDirection: isNumber ? TextDirection.ltr : TextDirection.rtl,
// //             style: TextStyle(
// //               color: const Color(0xFF003D2A),
// //               fontSize: isNumber ? 26 : 16,
// //               fontWeight: FontWeight.w900,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class _LogoMark extends StatelessWidget {
// //   const _LogoMark({required this.size});

// //   final double size;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       width: size,
// //       height: size,
// //       padding: const EdgeInsets.all(5),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         shape: BoxShape.circle,
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(.12),
// //             blurRadius: 14,
// //             offset: const Offset(0, 6),
// //           ),
// //         ],
// //       ),
// //       child: ClipOval(
// //         child: Image.asset(
// //           'assets/images/egypt_post_logo.png',
// //           fit: BoxFit.cover,
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class _StatPill extends StatelessWidget {
// //   const _StatPill({
// //     required this.icon,
// //     required this.label,
// //     required this.value,
// //   });

// //   final IconData icon;
// //   final String label;
// //   final String value;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(
// //         horizontal: 12,
// //         vertical: 10,
// //       ),
// //       decoration: BoxDecoration(
// //         color: Colors.white.withOpacity(.16),
// //         borderRadius: BorderRadius.circular(18),
// //         border: Border.all(
// //           color: Colors.white.withOpacity(.22),
// //         ),
// //       ),
// //       child: Row(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           Icon(
// //             icon,
// //             color: Colors.white,
// //             size: 20,
// //           ),
// //           const SizedBox(width: 8),
// //           Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Text(
// //                 value,
// //                 style: const TextStyle(
// //                   color: Colors.white,
// //                   fontWeight: FontWeight.w900,
// //                   fontSize: 15,
// //                 ),
// //               ),
// //               Text(
// //                 label,
// //                 style: TextStyle(
// //                   color: Colors.white.withOpacity(.82),
// //                   fontSize: 11,
// //                   fontWeight: FontWeight.w600,
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class _EmptyState extends StatelessWidget {
// //   const _EmptyState();

// //   @override
// //   Widget build(BuildContext context) {
// //     return Center(
// //       child: Padding(
// //         padding: const EdgeInsets.all(28),
// //         child: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             Image.asset(
// //               'assets/images/egypt_post_logo.png',
// //               width: 92,
// //               height: 92,
// //             ),
// //             const SizedBox(height: 18),
// //             const Text(
// //               'لا توجد نتائج مطابقة',
// //               style: TextStyle(
// //                 fontSize: 20,
// //                 fontWeight: FontWeight.w900,
// //                 color: Color(0xFF003D2A),
// //               ),
// //             ),
// //             const SizedBox(height: 8),
// //             const Text(
// //               'جرّب اسم أقصر، محافظة، وصف الوظيفة، أو رقم السيسكو مباشرة.',
// //               textAlign: TextAlign.center,
// //               style: TextStyle(
// //                 color: Color(0xFF70877E),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class _SearchHeaderDelegate extends SliverPersistentHeaderDelegate {
// //   _SearchHeaderDelegate({
// //     required this.child,
// //     required this.minHeight,
// //     required this.maxHeight,
// //   });

// //   final Widget child;
// //   final double minHeight;
// //   final double maxHeight;

// //   @override
// //   double get minExtent => minHeight;

// //   @override
// //   double get maxExtent => maxHeight;

// //   @override
// //   Widget build(
// //     BuildContext context,
// //     double shrinkOffset,
// //     bool overlapsContent,
// //   ) {
// //     return child;
// //   }

// //   @override
// //   bool shouldRebuild(covariant _SearchHeaderDelegate oldDelegate) {
// //     return oldDelegate.child != child ||
// //         oldDelegate.minHeight != minHeight ||
// //         oldDelegate.maxHeight != maxHeight;
// //   }
// // // }
// // import 'dart:convert';

// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:qr_flutter/qr_flutter.dart';
// // import 'package:share_plus/share_plus.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:speech_to_text/speech_to_text.dart' as stt;

// // void main() {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   runApp(const EgyptPostCiscoApp());
// // }

// // class EgyptPostCiscoApp extends StatefulWidget {
// //   const EgyptPostCiscoApp({super.key});

// //   @override
// //   State<EgyptPostCiscoApp> createState() => _EgyptPostCiscoAppState();
// // }

// // class _EgyptPostCiscoAppState extends State<EgyptPostCiscoApp> {
// //   ThemeMode _themeMode = ThemeMode.light;

// //   static const Color seed = Color(0xFF07965F);

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadThemeMode();
// //   }

// //   Future<void> _loadThemeMode() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     final isDark = prefs.getBool(AppPrefs.darkModeKey) ?? false;
// //     setState(() {
// //       _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
// //     });
// //   }

// //   Future<void> _toggleTheme(bool value) async {
// //     final prefs = await SharedPreferences.getInstance();
// //     await prefs.setBool(AppPrefs.darkModeKey, value);
// //     setState(() {
// //       _themeMode = value ? ThemeMode.dark : ThemeMode.light;
// //     });
// //   }

// //   ThemeData _lightTheme() {
// //     return ThemeData(
// //       useMaterial3: true,
// //       brightness: Brightness.light,
// //       colorScheme: ColorScheme.fromSeed(
// //         seedColor: seed,
// //         primary: seed,
// //         secondary: const Color(0xFF013F2B),
// //         surface: const Color(0xFFF4FBF7),
// //       ),
// //       scaffoldBackgroundColor: const Color(0xFFF4FBF7),
// //       fontFamily: 'Arial',
// //       appBarTheme: const AppBarTheme(
// //         centerTitle: true,
// //         backgroundColor: Colors.transparent,
// //         elevation: 0,
// //         foregroundColor: Color(0xFF003D2A),
// //       ),
// //       inputDecorationTheme: InputDecorationTheme(
// //         filled: true,
// //         fillColor: Colors.white,
// //         border: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(22),
// //           borderSide: BorderSide.none,
// //         ),
// //       ),
// //     );
// //   }

// //   ThemeData _darkTheme() {
// //     return ThemeData(
// //       useMaterial3: true,
// //       brightness: Brightness.dark,
// //       colorScheme: ColorScheme.fromSeed(
// //         brightness: Brightness.dark,
// //         seedColor: seed,
// //         primary: seed,
// //         secondary: const Color(0xFF22C483),
// //         surface: const Color(0xFF10241C),
// //       ),
// //       scaffoldBackgroundColor: const Color(0xFF071A13),
// //       fontFamily: 'Arial',
// //       appBarTheme: const AppBarTheme(
// //         centerTitle: true,
// //         backgroundColor: Colors.transparent,
// //         elevation: 0,
// //       ),
// //       inputDecorationTheme: InputDecorationTheme(
// //         filled: true,
// //         fillColor: const Color(0xFF10241C),
// //         border: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(22),
// //           borderSide: BorderSide.none,
// //         ),
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return AppSettingsScope(
// //       isDarkMode: _themeMode == ThemeMode.dark,
// //       onThemeChanged: _toggleTheme,
// //       child: MaterialApp(
// //         debugShowCheckedModeBanner: false,
// //         title: 'Egypt Post Cisco',
// //         theme: _lightTheme(),
// //         darkTheme: _darkTheme(),
// //         themeMode: _themeMode,
// //         home: const Directionality(
// //           textDirection: TextDirection.rtl,
// //           child: SplashScreen(),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class AppPrefs {
// //   static const String favoritesKey = 'favorite_cisco_ids';
// //   static const String recentSearchesKey = 'recent_searches';
// //   static const String onboardingDoneKey = 'onboarding_done';
// //   static const String darkModeKey = 'dark_mode_enabled';
// // }

// // class AppSettingsScope extends InheritedWidget {
// //   const AppSettingsScope({
// //     super.key,
// //     required super.child,
// //     required this.isDarkMode,
// //     required this.onThemeChanged,
// //   });

// //   final bool isDarkMode;
// //   final ValueChanged<bool> onThemeChanged;

// //   static AppSettingsScope of(BuildContext context) {
// //     final scope =
// //         context.dependOnInheritedWidgetOfExactType<AppSettingsScope>();
// //     assert(scope != null, 'AppSettingsScope not found');
// //     return scope!;
// //   }

// //   @override
// //   bool updateShouldNotify(AppSettingsScope oldWidget) {
// //     return oldWidget.isDarkMode != isDarkMode;
// //   }
// // }

// // class AppColors {
// //   static const green = Color(0xFF07965F);
// //   static const darkGreen = Color(0xFF003D2A);
// //   static const midGreen = Color(0xFF006B48);
// //   static const paleGreen = Color(0xFFF4FBF7);
// //   static const border = Color(0xFFE2F1EA);
// //   static const greyText = Color(0xFF70877E);
// // }

// // class CiscoEntry {
// //   CiscoEntry({
// //     required this.id,
// //     required this.region,
// //     required this.name,
// //     required this.description,
// //     required this.cisco,
// //     required this.notes,
// //   });

// //   final int id;
// //   final String region;
// //   final String name;
// //   final String description;
// //   final String cisco;
// //   final String notes;

// //   factory CiscoEntry.fromJson(Map<String, dynamic> json) {
// //     return CiscoEntry(
// //       id: json['id'] as int,
// //       region: json['region'] as String? ?? '',
// //       name: json['name'] as String? ?? '',
// //       description: json['description'] as String? ?? '',
// //       cisco: json['cisco'] as String? ?? '',
// //       notes: json['notes'] as String? ?? '',
// //     );
// //   }

// //   String get shareText {
// //     return '''
// // Egypt Post Cisco

// // الاسم: $name
// // المنطقة: $region
// // الوصف: ${description.isEmpty ? '-' : description}
// // رقم السيسكو: $cisco
// // ''';
// //   }
// // }

// // class SplashScreen extends StatefulWidget {
// //   const SplashScreen({super.key});

// //   @override
// //   State<SplashScreen> createState() => _SplashScreenState();
// // }

// // class _SplashScreenState extends State<SplashScreen>
// //     with SingleTickerProviderStateMixin {
// //   late final AnimationController _controller;
// //   late final Animation<double> _fadeAnimation;
// //   late final Animation<double> _scaleAnimation;
// //   late final Animation<Offset> _slideAnimation;

// //   @override
// //   void initState() {
// //     super.initState();

// //     _controller = AnimationController(
// //       vsync: this,
// //       duration: const Duration(milliseconds: 1800),
// //     );

// //     _fadeAnimation = CurvedAnimation(
// //       parent: _controller,
// //       curve: Curves.easeOut,
// //     );

// //     _scaleAnimation = Tween<double>(begin: .82, end: 1).animate(
// //       CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
// //     );

// //     _slideAnimation = Tween<Offset>(
// //       begin: const Offset(0, .18),
// //       end: Offset.zero,
// //     ).animate(
// //       CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
// //     );

// //     _controller.forward();

// //     Future.delayed(const Duration(seconds: 4), () {
// //       if (!mounted) return;

// //       Navigator.of(context).pushReplacement(
// //         PageRouteBuilder(
// //           transitionDuration: const Duration(milliseconds: 850),
// //           pageBuilder: (_, animation, __) {
// //             return FadeTransition(
// //               opacity: animation,
// //               child: const Directionality(
// //                 textDirection: TextDirection.rtl,
// //                 child: MainShell(),
// //               ),
// //             );
// //           },
// //         ),
// //       );
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     _controller.dispose();
// //     super.dispose();
// //   }

// //   Widget _backgroundLogo({
// //     required double size,
// //     required double opacity,
// //   }) {
// //     return Opacity(
// //       opacity: opacity,
// //       child: Image.asset(
// //         'assets/images/egypt_post_logo.png',
// //         width: size,
// //         height: size,
// //         fit: BoxFit.cover,
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: AnnotatedRegion<SystemUiOverlayStyle>(
// //         value: SystemUiOverlayStyle.light,
// //         child: Container(
// //           width: double.infinity,
// //           height: double.infinity,
// //           decoration: const BoxDecoration(
// //             gradient: LinearGradient(
// //               begin: Alignment.topRight,
// //               end: Alignment.bottomLeft,
// //               colors: [
// //                 AppColors.green,
// //                 AppColors.midGreen,
// //                 AppColors.darkGreen,
// //               ],
// //             ),
// //           ),
// //           child: Stack(
// //             children: [
// //               PositionedDirectional(
// //                 top: -95,
// //                 end: -75,
// //                 child: _backgroundLogo(size: 285, opacity: .09),
// //               ),
// //               PositionedDirectional(
// //                 bottom: -110,
// //                 start: -90,
// //                 child: _backgroundLogo(size: 320, opacity: .075),
// //               ),
// //               PositionedDirectional(
// //                 top: MediaQuery.of(context).padding.top + 34,
// //                 start: 26,
// //                 child: Container(
// //                   padding: const EdgeInsets.symmetric(
// //                     horizontal: 14,
// //                     vertical: 8,
// //                   ),
// //                   decoration: BoxDecoration(
// //                     color: Colors.white.withOpacity(.13),
// //                     borderRadius: BorderRadius.circular(100),
// //                     border: Border.all(color: Colors.white.withOpacity(.22)),
// //                   ),
// //                   child: const Row(
// //                     mainAxisSize: MainAxisSize.min,
// //                     children: [
// //                       Icon(Icons.security_rounded,
// //                           color: Colors.white, size: 18),
// //                       SizedBox(width: 7),
// //                       Text(
// //                         'منطقة برج العرب',
// //                         style: TextStyle(
// //                           color: Colors.white,
// //                           fontWeight: FontWeight.w800,
// //                           fontSize: 13,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //               Center(
// //                 child: FadeTransition(
// //                   opacity: _fadeAnimation,
// //                   child: SlideTransition(
// //                     position: _slideAnimation,
// //                     child: ScaleTransition(
// //                       scale: _scaleAnimation,
// //                       child: Padding(
// //                         padding: const EdgeInsets.symmetric(horizontal: 26),
// //                         child: Column(
// //                           mainAxisSize: MainAxisSize.min,
// //                           children: [
// //                             Container(
// //                               width: 144,
// //                               height: 144,
// //                               padding: const EdgeInsets.all(8),
// //                               decoration: BoxDecoration(
// //                                 color: Colors.white,
// //                                 shape: BoxShape.circle,
// //                                 boxShadow: [
// //                                   BoxShadow(
// //                                     color: Colors.black.withOpacity(.25),
// //                                     blurRadius: 32,
// //                                     offset: const Offset(0, 16),
// //                                   ),
// //                                 ],
// //                               ),
// //                               child: ClipOval(
// //                                 child: Image.asset(
// //                                   'assets/images/egypt_post_logo.png',
// //                                   fit: BoxFit.cover,
// //                                 ),
// //                               ),
// //                             ),
// //                             const SizedBox(height: 28),
// //                             const Text(
// //                               'Egypt Post Cisco',
// //                               textDirection: TextDirection.ltr,
// //                               textAlign: TextAlign.center,
// //                               style: TextStyle(
// //                                 color: Colors.white,
// //                                 fontSize: 31,
// //                                 fontWeight: FontWeight.w900,
// //                                 letterSpacing: .4,
// //                               ),
// //                             ),
// //                             const SizedBox(height: 9),
// //                             Text(
// //                               'دليل أرقام السيسكو للبريد المصري',
// //                               textAlign: TextAlign.center,
// //                               style: TextStyle(
// //                                 color: Colors.white.withOpacity(.88),
// //                                 fontSize: 15,
// //                                 fontWeight: FontWeight.w700,
// //                               ),
// //                             ),
// //                             const SizedBox(height: 34),
// //                             Container(
// //                               width: double.infinity,
// //                               padding: const EdgeInsets.symmetric(
// //                                 horizontal: 20,
// //                                 vertical: 23,
// //                               ),
// //                               decoration: BoxDecoration(
// //                                 color: Colors.white.withOpacity(.14),
// //                                 borderRadius: BorderRadius.circular(28),
// //                                 border: Border.all(
// //                                   color: Colors.white.withOpacity(.24),
// //                                 ),
// //                                 boxShadow: [
// //                                   BoxShadow(
// //                                     color: Colors.black.withOpacity(.10),
// //                                     blurRadius: 24,
// //                                     offset: const Offset(0, 12),
// //                                   ),
// //                                 ],
// //                               ),
// //                               child: Column(
// //                                 children: [
// //                                   Container(
// //                                     width: 48,
// //                                     height: 5,
// //                                     decoration: BoxDecoration(
// //                                       color: Colors.white.withOpacity(.55),
// //                                       borderRadius: BorderRadius.circular(100),
// //                                     ),
// //                                   ),
// //                                   const SizedBox(height: 18),
// //                                   const Text(
// //                                     'هدية من إدارة التكنولوجيا والمعلومات\nبمنطقة برج العرب\nإلى جميع موظفي البريد المصري',
// //                                     textAlign: TextAlign.center,
// //                                     style: TextStyle(
// //                                       color: Colors.white,
// //                                       fontSize: 18,
// //                                       height: 1.7,
// //                                       fontWeight: FontWeight.w900,
// //                                     ),
// //                                   ),
// //                                 ],
// //                               ),
// //                             ),
// //                             const SizedBox(height: 34),
// //                             SizedBox(
// //                               width: 36,
// //                               height: 36,
// //                               child: CircularProgressIndicator(
// //                                 strokeWidth: 3,
// //                                 valueColor: const AlwaysStoppedAnimation<Color>(
// //                                   Colors.white,
// //                                 ),
// //                                 backgroundColor: Colors.white.withOpacity(.22),
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //               PositionedDirectional(
// //                 bottom: MediaQuery.of(context).padding.bottom + 28,
// //                 start: 24,
// //                 end: 24,
// //                 child: Text(
// //                   'Powered by Egypt Post Technology & Information',
// //                   textDirection: TextDirection.ltr,
// //                   textAlign: TextAlign.center,
// //                   style: TextStyle(
// //                     color: Colors.white.withOpacity(.62),
// //                     fontSize: 12,
// //                     fontWeight: FontWeight.w600,
// //                     letterSpacing: .2,
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class MainShell extends StatefulWidget {
// //   const MainShell({super.key});

// //   @override
// //   State<MainShell> createState() => _MainShellState();
// // }

// // class _MainShellState extends State<MainShell> {
// //   int _index = 0;

// //   List<CiscoEntry> _all = const [];
// //   List<String> _regions = const [];
// //   Set<int> _favorites = {};
// //   List<String> _recentSearches = [];
// //   bool _loading = true;

// //   final GlobalKey<CiscoHomePageState> _homeKey =
// //       GlobalKey<CiscoHomePageState>();

// //   @override
// //   void initState() {
// //     super.initState();
// //     _bootstrap();
// //   }

// //   Future<void> _bootstrap() async {
// //     await Future.wait([
// //       _loadData(),
// //       _loadFavorites(),
// //       _loadRecentSearches(),
// //     ]);

// //     if (!mounted) return;

// //     setState(() => _loading = false);
// //     await _showOnboardingIfNeeded();
// //   }

// //   Future<void> _loadData() async {
// //     final raw = await rootBundle.loadString('assets/data/cisco_directory.json');
// //     final decoded = jsonDecode(raw) as List<dynamic>;
// //     final loaded = decoded
// //         .map((e) => CiscoEntry.fromJson(e as Map<String, dynamic>))
// //         .toList(growable: false);

// //     final regions = loaded.map((e) => e.region).toSet().toList()..sort();

// //     _all = loaded;
// //     _regions = ['كل المناطق', ...regions];
// //   }

// //   Future<void> _loadFavorites() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     final raw = prefs.getStringList(AppPrefs.favoritesKey) ?? [];
// //     _favorites = raw.map(int.parse).toSet();
// //   }

// //   Future<void> _loadRecentSearches() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     _recentSearches = prefs.getStringList(AppPrefs.recentSearchesKey) ?? [];
// //   }

// //   Future<void> _saveFavorites() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     await prefs.setStringList(
// //       AppPrefs.favoritesKey,
// //       _favorites.map((e) => e.toString()).toList(),
// //     );
// //   }

// //   Future<void> _saveRecentSearch(String value) async {
// //     final query = value.trim();
// //     if (query.isEmpty) return;

// //     _recentSearches.removeWhere((e) => e == query);
// //     _recentSearches.insert(0, query);

// //     if (_recentSearches.length > 10) {
// //       _recentSearches = _recentSearches.take(10).toList();
// //     }

// //     final prefs = await SharedPreferences.getInstance();
// //     await prefs.setStringList(AppPrefs.recentSearchesKey, _recentSearches);

// //     if (mounted) setState(() {});
// //   }

// //   Future<void> _clearRecentSearches() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     await prefs.remove(AppPrefs.recentSearchesKey);
// //     setState(() => _recentSearches = []);
// //   }

// //   Future<void> _showOnboardingIfNeeded() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     final done = prefs.getBool(AppPrefs.onboardingDoneKey) ?? false;

// //     if (done || !mounted) return;

// //     await showDialog<void>(
// //       context: context,
// //       barrierDismissible: false,
// //       builder: (_) => Directionality(
// //         textDirection: TextDirection.rtl,
// //         child: AlertDialog(
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(26),
// //           ),
// //           title: const Text(
// //             'مرحبًا بك في Egypt Post Cisco',
// //             style: TextStyle(fontWeight: FontWeight.w900),
// //           ),
// //           content: const Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               _OnboardingItem(
// //                 icon: Icons.search_rounded,
// //                 title: 'بحث سريع',
// //                 text: 'ابحث بالاسم، المكان، الوظيفة أو رقم السيسكو.',
// //               ),
// //               SizedBox(height: 12),
// //               _OnboardingItem(
// //                 icon: Icons.star_rounded,
// //                 title: 'المفضلة',
// //                 text: 'احفظ الأرقام المهمة للوصول لها بسرعة.',
// //               ),
// //               SizedBox(height: 12),
// //               _OnboardingItem(
// //                 icon: Icons.share_rounded,
// //                 title: 'مشاركة و QR',
// //                 text: 'شارك بيانات الجهة أو اعرض الرقم كـ QR Code.',
// //               ),
// //             ],
// //           ),
// //           actions: [
// //             FilledButton(
// //               onPressed: () async {
// //                 await prefs.setBool(AppPrefs.onboardingDoneKey, true);
// //                 if (context.mounted) Navigator.pop(context);
// //               },
// //               child: const Text('ابدأ الآن'),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Future<void> _toggleFavorite(CiscoEntry entry) async {
// //     setState(() {
// //       if (_favorites.contains(entry.id)) {
// //         _favorites.remove(entry.id);
// //       } else {
// //         _favorites.add(entry.id);
// //       }
// //     });

// //     await _saveFavorites();
// //   }

// //   void _openSearchWith({
// //     String? query,
// //     String? type,
// //     String? region,
// //   }) {
// //     setState(() => _index = 0);

// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       _homeKey.currentState?.setSearchAndFilters(
// //         query: query,
// //         type: type,
// //         region: region,
// //       );
// //     });
// //   }

// //   void _openDetails(CiscoEntry entry) {
// //     showCiscoDetails(
// //       context: context,
// //       entry: entry,
// //       isFavorite: _favorites.contains(entry.id),
// //       onToggleFavorite: () => _toggleFavorite(entry),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     if (_loading) {
// //       return const Scaffold(
// //         body: Center(child: CircularProgressIndicator()),
// //       );
// //     }

// //     final pages = [
// //       CiscoHomePage(
// //         key: _homeKey,
// //         all: _all,
// //         regions: _regions,
// //         favorites: _favorites,
// //         recentSearches: _recentSearches,
// //         onSaveRecentSearch: _saveRecentSearch,
// //         onClearRecentSearches: _clearRecentSearches,
// //         onToggleFavorite: _toggleFavorite,
// //         onOpenDetails: _openDetails,
// //       ),
// //       CardsHubScreen(
// //         all: _all,
// //         regions: _regions,
// //         favoritesCount: _favorites.length,
// //         recentSearches: _recentSearches,
// //         onOpenSearch: _openSearchWith,
// //       ),
// //       FavoritesScreen(
// //         all: _all,
// //         favorites: _favorites,
// //         onToggleFavorite: _toggleFavorite,
// //         onOpenDetails: _openDetails,
// //       ),
// //       SettingsScreen(
// //         total: _all.length,
// //         favoritesCount: _favorites.length,
// //         recentCount: _recentSearches.length,
// //         onClearRecent: _clearRecentSearches,
// //       ),
// //     ];

// //     return Scaffold(
// //       body: IndexedStack(
// //         index: _index,
// //         children: pages,
// //       ),
// //       bottomNavigationBar: NavigationBar(
// //         selectedIndex: _index,
// //         onDestinationSelected: (value) => setState(() => _index = value),
// //         destinations: const [
// //           NavigationDestination(
// //             icon: Icon(Icons.search_rounded),
// //             selectedIcon: Icon(Icons.search_rounded),
// //             label: 'البحث',
// //           ),
// //           NavigationDestination(
// //             icon: Icon(Icons.dashboard_outlined),
// //             selectedIcon: Icon(Icons.dashboard_rounded),
// //             label: 'الأقسام',
// //           ),
// //           NavigationDestination(
// //             icon: Icon(Icons.star_border_rounded),
// //             selectedIcon: Icon(Icons.star_rounded),
// //             label: 'المفضلة',
// //           ),
// //           NavigationDestination(
// //             icon: Icon(Icons.settings_outlined),
// //             selectedIcon: Icon(Icons.settings_rounded),
// //             label: 'الإعدادات',
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class CiscoHomePage extends StatefulWidget {
// //   const CiscoHomePage({
// //     super.key,
// //     required this.all,
// //     required this.regions,
// //     required this.favorites,
// //     required this.recentSearches,
// //     required this.onSaveRecentSearch,
// //     required this.onClearRecentSearches,
// //     required this.onToggleFavorite,
// //     required this.onOpenDetails,
// //   });

// //   final List<CiscoEntry> all;
// //   final List<String> regions;
// //   final Set<int> favorites;
// //   final List<String> recentSearches;
// //   final Future<void> Function(String value) onSaveRecentSearch;
// //   final Future<void> Function() onClearRecentSearches;
// //   final Future<void> Function(CiscoEntry entry) onToggleFavorite;
// //   final void Function(CiscoEntry entry) onOpenDetails;

// //   @override
// //   State<CiscoHomePage> createState() => CiscoHomePageState();
// // }

// // class CiscoHomePageState extends State<CiscoHomePage> {
// //   final TextEditingController _searchController = TextEditingController();
// //   final FocusNode _searchFocus = FocusNode();
// //   final stt.SpeechToText _speech = stt.SpeechToText();

// //   List<CiscoEntry> _filtered = const [];
// //   List<String> _suggestions = const [];

// //   String _query = '';
// //   String _selectedRegion = 'كل المناطق';
// //   String _selectedType = 'الكل';

// //   bool _voiceAvailable = false;
// //   bool _isListening = false;

// //   static const List<String> _types = [
// //     'الكل',
// //     'مكاتب البريد',
// //     'مناطق التوزيع',
// //     'القطاعات',
// //   ];

// //   @override
// //   void initState() {
// //     super.initState();

// //     _filtered = _rankedResults(widget.all, '');

// //     _searchController.addListener(() {
// //       _query = _searchController.text;
// //       _applyFilters();
// //       _buildSuggestions();
// //     });

// //     _initVoice();
// //   }

// //   Future<void> _initVoice() async {
// //     final available = await _speech.initialize();
// //     if (!mounted) return;
// //     setState(() => _voiceAvailable = available);
// //   }

// //   Future<void> _startVoiceSearch() async {
// //     if (!_voiceAvailable) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(
// //           content: Text('البحث الصوتي غير متاح على هذا الجهاز.'),
// //           behavior: SnackBarBehavior.floating,
// //         ),
// //       );
// //       return;
// //     }

// //     if (_isListening) {
// //       await _speech.stop();
// //       setState(() => _isListening = false);
// //       return;
// //     }

// //     setState(() => _isListening = true);

// //     await _speech.listen(
// //       localeId: 'ar_EG',
// //       listenMode: stt.ListenMode.search,
// //       onResult: (result) {
// //         final recognized = result.recognizedWords.trim();
// //         if (recognized.isNotEmpty) {
// //           _searchController.text = recognized;
// //           _searchController.selection = TextSelection.collapsed(
// //             offset: recognized.length,
// //           );
// //         }

// //         if (result.finalResult) {
// //           setState(() => _isListening = false);
// //           widget.onSaveRecentSearch(recognized);
// //         }
// //       },
// //     );
// //   }

// //   void setSearchAndFilters({
// //     String? query,
// //     String? type,
// //     String? region,
// //   }) {
// //     if (query != null) {
// //       _searchController.text = query;
// //       _searchController.selection = TextSelection.collapsed(
// //         offset: query.length,
// //       );
// //     }

// //     setState(() {
// //       if (type != null) _selectedType = type;
// //       if (region != null) _selectedRegion = region;
// //     });

// //     _applyFilters();
// //   }

// //   String _normalize(String value) {
// //     return value
// //         .replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '')
// //         .replaceAll('أ', 'ا')
// //         .replaceAll('إ', 'ا')
// //         .replaceAll('آ', 'ا')
// //         .replaceAll('ى', 'ي')
// //         .replaceAll('ة', 'ه')
// //         .replaceAll('ؤ', 'و')
// //         .replaceAll('ئ', 'ي')
// //         .replaceAll('ٱ', 'ا')
// //         .replaceAll(RegExp(r'\s+'), ' ')
// //         .replaceAll('برج العرب', 'برجالعرب')
// //         .trim()
// //         .toLowerCase();
// //   }

// //   bool _matchesType(CiscoEntry item) {
// //     switch (_selectedType) {
// //       case 'مكاتب البريد':
// //         return item.description.contains('مكتب بريد');
// //       case 'مناطق التوزيع':
// //         return item.region.contains('مناطق التوزيع') ||
// //             item.description.contains('توزيع');
// //       case 'القطاعات':
// //         return item.region.contains('القطاعات');
// //       default:
// //         return true;
// //     }
// //   }

// //   int _score(CiscoEntry item, String q) {
// //     if (q.isEmpty) return 1;

// //     final cisco = _normalize(item.cisco);
// //     final name = _normalize(item.name);
// //     final region = _normalize(item.region);
// //     final description = _normalize(item.description);
// //     final notes = _normalize(item.notes);

// //     if (cisco == q) return 1000;
// //     if (cisco.startsWith(q)) return 900;
// //     if (name == q) return 850;
// //     if (name.startsWith(q)) return 800;
// //     if (name.contains(q)) return 700;
// //     if (region.startsWith(q)) return 600;
// //     if (region.contains(q)) return 500;
// //     if (description.contains(q)) return 400;
// //     if (notes.contains(q)) return 300;

// //     final haystack = '$name $region $description $cisco $notes';
// //     if (haystack.contains(q)) return 100;

// //     return 0;
// //   }

// //   List<CiscoEntry> _rankedResults(List<CiscoEntry> source, String query) {
// //     final q = _normalize(query);

// //     final scored = source
// //         .map((entry) => MapEntry(entry, _score(entry, q)))
// //         .where((pair) => q.isEmpty || pair.value > 0)
// //         .toList();

// //     scored.sort((a, b) => b.value.compareTo(a.value));

// //     return scored.map((e) => e.key).toList(growable: false);
// //   }

// //   void _applyFilters() {
// //     final resultSource = widget.all.where((item) {
// //       final regionOk =
// //           _selectedRegion == 'كل المناطق' || item.region == _selectedRegion;
// //       final typeOk = _matchesType(item);
// //       return regionOk && typeOk;
// //     }).toList();

// //     final ranked = _rankedResults(resultSource, _query);

// //     setState(() => _filtered = ranked);
// //   }

// //   void _buildSuggestions() {
// //     final q = _normalize(_query);

// //     if (q.isEmpty) {
// //       setState(() => _suggestions = const []);
// //       return;
// //     }

// //     final names = <String>{};

// //     for (final item in widget.all) {
// //       final values = [
// //         item.name,
// //         item.region,
// //         item.description,
// //         item.cisco,
// //       ];

// //       for (final value in values) {
// //         if (value.trim().isEmpty) continue;
// //         if (_normalize(value).contains(q)) {
// //           names.add(value.trim());
// //         }
// //       }

// //       if (names.length >= 8) break;
// //     }

// //     setState(() => _suggestions = names.take(8).toList());
// //   }

// //   Future<void> _onSearchSubmitted(String value) async {
// //     await widget.onSaveRecentSearch(value);
// //     _searchFocus.unfocus();
// //   }

// //   void _openAdvancedFilter() {
// //     String tempRegion = _selectedRegion;
// //     String tempType = _selectedType;

// //     showModalBottomSheet<void>(
// //       context: context,
// //       showDragHandle: true,
// //       backgroundColor: Theme.of(context).colorScheme.surface,
// //       shape: const RoundedRectangleBorder(
// //         borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
// //       ),
// //       builder: (_) {
// //         return Directionality(
// //           textDirection: TextDirection.rtl,
// //           child: StatefulBuilder(
// //             builder: (context, setSheetState) {
// //               return Padding(
// //                 padding: EdgeInsets.only(
// //                   left: 20,
// //                   right: 20,
// //                   top: 6,
// //                   bottom: MediaQuery.of(context).padding.bottom + 22,
// //                 ),
// //                 child: Column(
// //                   mainAxisSize: MainAxisSize.min,
// //                   children: [
// //                     const Text(
// //                       'فلترة متقدمة',
// //                       style: TextStyle(
// //                         fontSize: 22,
// //                         fontWeight: FontWeight.w900,
// //                       ),
// //                     ),
// //                     const SizedBox(height: 16),
// //                     DropdownButtonFormField<String>(
// //                       value: tempRegion,
// //                       isExpanded: true,
// //                       items: widget.regions
// //                           .map(
// //                             (region) => DropdownMenuItem(
// //                               value: region,
// //                               child: Text(
// //                                 region,
// //                                 maxLines: 1,
// //                                 overflow: TextOverflow.ellipsis,
// //                               ),
// //                             ),
// //                           )
// //                           .toList(),
// //                       onChanged: (value) {
// //                         setSheetState(() {
// //                           tempRegion = value ?? 'كل المناطق';
// //                         });
// //                       },
// //                       decoration: const InputDecoration(
// //                         labelText: 'المنطقة',
// //                         prefixIcon: Icon(Icons.location_on_outlined),
// //                       ),
// //                     ),
// //                     const SizedBox(height: 12),
// //                     DropdownButtonFormField<String>(
// //                       value: tempType,
// //                       isExpanded: true,
// //                       items: _types
// //                           .map(
// //                             (type) => DropdownMenuItem(
// //                               value: type,
// //                               child: Text(type),
// //                             ),
// //                           )
// //                           .toList(),
// //                       onChanged: (value) {
// //                         setSheetState(() {
// //                           tempType = value ?? 'الكل';
// //                         });
// //                       },
// //                       decoration: const InputDecoration(
// //                         labelText: 'نوع الجهة',
// //                         prefixIcon: Icon(Icons.category_outlined),
// //                       ),
// //                     ),
// //                     const SizedBox(height: 18),
// //                     Row(
// //                       children: [
// //                         Expanded(
// //                           child: FilledButton.icon(
// //                             onPressed: () {
// //                               setState(() {
// //                                 _selectedRegion = tempRegion;
// //                                 _selectedType = tempType;
// //                               });
// //                               _applyFilters();
// //                               Navigator.pop(context);
// //                             },
// //                             icon: const Icon(Icons.check_rounded),
// //                             label: const Text('تطبيق الفلتر'),
// //                           ),
// //                         ),
// //                         const SizedBox(width: 10),
// //                         IconButton.filledTonal(
// //                           onPressed: () {
// //                             setSheetState(() {
// //                               tempRegion = 'كل المناطق';
// //                               tempType = 'الكل';
// //                             });
// //                           },
// //                           icon: const Icon(Icons.refresh_rounded),
// //                         ),
// //                       ],
// //                     ),
// //                   ],
// //                 ),
// //               );
// //             },
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   void _resetFilters() {
// //     _searchController.clear();
// //     setState(() {
// //       _selectedRegion = 'كل المناطق';
// //       _selectedType = 'الكل';
// //       _suggestions = const [];
// //     });
// //     _applyFilters();
// //   }

// //   @override
// //   void dispose() {
// //     _searchController.dispose();
// //     _searchFocus.dispose();
// //     _speech.stop();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       floatingActionButton: FloatingActionButton.extended(
// //         onPressed: () => _searchFocus.requestFocus(),
// //         icon: const Icon(Icons.search_rounded),
// //         label: const Text('بحث سريع'),
// //       ),
// //       body: CustomScrollView(
// //         slivers: [
// //           SliverToBoxAdapter(child: _HeroHeader(total: widget.all.length)),
// //           SliverPersistentHeader(
// //             pinned: true,
// //             delegate: _SearchHeaderDelegate(
// //               minHeight: 285,
// //               maxHeight: 285,
// //               child: _SearchPanel(
// //                 controller: _searchController,
// //                 focusNode: _searchFocus,
// //                 selectedRegion: _selectedRegion,
// //                 selectedType: _selectedType,
// //                 resultCount: _filtered.length,
// //                 suggestions: _suggestions,
// //                 recentSearches: widget.recentSearches,
// //                 isListening: _isListening,
// //                 onVoiceTap: _startVoiceSearch,
// //                 onSuggestionTap: (value) {
// //                   _searchController.text = value;
// //                   _searchController.selection = TextSelection.collapsed(
// //                     offset: value.length,
// //                   );
// //                   widget.onSaveRecentSearch(value);
// //                 },
// //                 onRecentTap: (value) {
// //                   _searchController.text = value;
// //                   _searchController.selection = TextSelection.collapsed(
// //                     offset: value.length,
// //                   );
// //                 },
// //                 onClearRecent: widget.onClearRecentSearches,
// //                 onAdvancedFilter: _openAdvancedFilter,
// //                 onReset: _resetFilters,
// //                 onSubmitted: _onSearchSubmitted,
// //               ),
// //             ),
// //           ),
// //           if (_filtered.isEmpty)
// //             SliverFillRemaining(
// //               hasScrollBody: false,
// //               child: _EmptyState(onReset: _resetFilters),
// //             )
// //           else
// //             SliverPadding(
// //               padding: const EdgeInsets.fromLTRB(16, 10, 16, 90),
// //               sliver: SliverList.separated(
// //                 itemCount: _filtered.length,
// //                 separatorBuilder: (_, __) => const SizedBox(height: 10),
// //                 itemBuilder: (context, index) {
// //                   final item = _filtered[index];

// //                   return _ResultCard(
// //                     entry: item,
// //                     isFavorite: widget.favorites.contains(item.id),
// //                     onTap: () => widget.onOpenDetails(item),
// //                     onFavoriteTap: () => widget.onToggleFavorite(item),
// //                   );
// //                 },
// //               ),
// //             ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class _HeroHeader extends StatelessWidget {
// //   const _HeroHeader({required this.total});

// //   final int total;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       padding: EdgeInsets.only(
// //         top: MediaQuery.of(context).padding.top + 22,
// //         left: 18,
// //         right: 18,
// //         bottom: 22,
// //       ),
// //       decoration: const BoxDecoration(
// //         gradient: LinearGradient(
// //           begin: Alignment.topRight,
// //           end: Alignment.bottomLeft,
// //           colors: [AppColors.green, AppColors.midGreen],
// //         ),
// //         borderRadius: BorderRadius.vertical(bottom: Radius.circular(34)),
// //       ),
// //       child: Stack(
// //         children: [
// //           PositionedDirectional(
// //             end: -45,
// //             bottom: -55,
// //             child: Opacity(
// //               opacity: .12,
// //               child: Image.asset(
// //                 'assets/images/egypt_post_logo.png',
// //                 width: 210,
// //                 height: 210,
// //               ),
// //             ),
// //           ),
// //           Column(
// //             crossAxisAlignment: CrossAxisAlignment.stretch,
// //             children: [
// //               Row(
// //                 children: [
// //                   const _LogoMark(size: 72),
// //                   const SizedBox(width: 14),
// //                   Expanded(
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         const Text(
// //                           'Egypt Post Cisco',
// //                           textDirection: TextDirection.ltr,
// //                           style: TextStyle(
// //                             color: Colors.white,
// //                             fontSize: 24,
// //                             fontWeight: FontWeight.w900,
// //                             letterSpacing: .3,
// //                           ),
// //                         ),
// //                         Text(
// //                           'دليل أرقام السيسكو للبريد المصري',
// //                           style: TextStyle(
// //                             color: Colors.white.withOpacity(.86),
// //                             fontSize: 14,
// //                             fontWeight: FontWeight.w600,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //               const SizedBox(height: 24),
// //               Wrap(
// //                 spacing: 10,
// //                 runSpacing: 10,
// //                 children: [
// //                   _StatPill(
// //                     icon: Icons.dialpad_rounded,
// //                     label: 'رقم محفوظ',
// //                     value: '$total+',
// //                   ),
// //                   const _StatPill(
// //                     icon: Icons.public_rounded,
// //                     label: 'بحث باسم أو مكان',
// //                     value: 'ذكي',
// //                   ),
// //                   const _StatPill(
// //                     icon: Icons.offline_bolt_rounded,
// //                     label: 'بدون إنترنت',
// //                     value: 'Offline',
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class _SearchPanel extends StatelessWidget {
// //   const _SearchPanel({
// //     required this.controller,
// //     required this.focusNode,
// //     required this.selectedRegion,
// //     required this.selectedType,
// //     required this.resultCount,
// //     required this.suggestions,
// //     required this.recentSearches,
// //     required this.isListening,
// //     required this.onVoiceTap,
// //     required this.onSuggestionTap,
// //     required this.onRecentTap,
// //     required this.onClearRecent,
// //     required this.onAdvancedFilter,
// //     required this.onReset,
// //     required this.onSubmitted,
// //   });

// //   final TextEditingController controller;
// //   final FocusNode focusNode;
// //   final String selectedRegion;
// //   final String selectedType;
// //   final int resultCount;
// //   final List<String> suggestions;
// //   final List<String> recentSearches;
// //   final bool isListening;
// //   final VoidCallback onVoiceTap;
// //   final ValueChanged<String> onSuggestionTap;
// //   final ValueChanged<String> onRecentTap;
// //   final VoidCallback onClearRecent;
// //   final VoidCallback onAdvancedFilter;
// //   final VoidCallback onReset;
// //   final ValueChanged<String> onSubmitted;

// //   @override
// //   Widget build(BuildContext context) {
// //     final visibleChips = suggestions.isNotEmpty ? suggestions : recentSearches;
// //     final chipTitle = suggestions.isNotEmpty ? 'اقتراحات' : 'آخر بحث';

// //     return Material(
// //       color: Theme.of(context).scaffoldBackgroundColor,
// //       child: Padding(
// //         padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
// //         child: Column(
// //           children: [
// //             TextField(
// //               controller: controller,
// //               focusNode: focusNode,
// //               textInputAction: TextInputAction.search,
// //               onSubmitted: onSubmitted,
// //               decoration: InputDecoration(
// //                 hintText:
// //                     'ابحث باسم المكتب، المكان، الوظيفة، أو رقم السيسكو...',
// //                 prefixIcon: const Icon(Icons.search_rounded),
// //                 suffixIcon: Row(
// //                   mainAxisSize: MainAxisSize.min,
// //                   children: [
// //                     IconButton(
// //                       tooltip: 'بحث بالصوت',
// //                       onPressed: onVoiceTap,
// //                       icon: Icon(
// //                         isListening
// //                             ? Icons.mic_rounded
// //                             : Icons.mic_none_rounded,
// //                         color: isListening ? Colors.red : null,
// //                       ),
// //                     ),
// //                     if (controller.text.isNotEmpty)
// //                       IconButton(
// //                         tooltip: 'مسح البحث',
// //                         onPressed: controller.clear,
// //                         icon: const Icon(Icons.close_rounded),
// //                       ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(height: 10),
// //             Row(
// //               children: [
// //                 Expanded(
// //                   child: FilledButton.tonalIcon(
// //                     onPressed: onAdvancedFilter,
// //                     icon: const Icon(Icons.tune_rounded),
// //                     label: Text(
// //                       '$selectedRegion | $selectedType',
// //                       maxLines: 1,
// //                       overflow: TextOverflow.ellipsis,
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(width: 10),
// //                 IconButton.filledTonal(
// //                   tooltip: 'إعادة ضبط',
// //                   onPressed: onReset,
// //                   icon: const Icon(Icons.refresh_rounded),
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 10),
// //             if (visibleChips.isNotEmpty)
// //               SizedBox(
// //                 height: 82,
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Row(
// //                       children: [
// //                         Text(
// //                           chipTitle,
// //                           style: const TextStyle(
// //                             fontWeight: FontWeight.w900,
// //                             fontSize: 12,
// //                           ),
// //                         ),
// //                         const Spacer(),
// //                         if (suggestions.isEmpty && recentSearches.isNotEmpty)
// //                           TextButton(
// //                             onPressed: onClearRecent,
// //                             child: const Text('مسح'),
// //                           ),
// //                       ],
// //                     ),
// //                     SizedBox(
// //                       height: 44,
// //                       child: ListView.separated(
// //                         scrollDirection: Axis.horizontal,
// //                         itemCount: visibleChips.length,
// //                         separatorBuilder: (_, __) => const SizedBox(width: 8),
// //                         itemBuilder: (context, index) {
// //                           final item = visibleChips[index];

// //                           return ActionChip(
// //                             avatar: Icon(
// //                               suggestions.isNotEmpty
// //                                   ? Icons.bolt_rounded
// //                                   : Icons.history_rounded,
// //                               size: 17,
// //                             ),
// //                             label: Text(
// //                               item,
// //                               maxLines: 1,
// //                               overflow: TextOverflow.ellipsis,
// //                             ),
// //                             onPressed: () {
// //                               if (suggestions.isNotEmpty) {
// //                                 onSuggestionTap(item);
// //                               } else {
// //                                 onRecentTap(item);
// //                               }
// //                             },
// //                           );
// //                         },
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               )
// //             else
// //               const SizedBox(height: 82),
// //             Row(
// //               children: [
// //                 const Icon(
// //                   Icons.format_list_numbered_rtl_rounded,
// //                   size: 18,
// //                   color: AppColors.green,
// //                 ),
// //                 const SizedBox(width: 6),
// //                 Text(
// //                   '$resultCount نتيجة',
// //                   style: const TextStyle(fontWeight: FontWeight.w900),
// //                 ),
// //                 const Spacer(),
// //                 const Text(
// //                   'اضغط على أي نتيجة للتفاصيل',
// //                   style: TextStyle(color: AppColors.greyText, fontSize: 12),
// //                 ),
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class _ResultCard extends StatelessWidget {
// //   const _ResultCard({
// //     required this.entry,
// //     required this.isFavorite,
// //     required this.onTap,
// //     required this.onFavoriteTap,
// //   });

// //   final CiscoEntry entry;
// //   final bool isFavorite;
// //   final VoidCallback onTap;
// //   final VoidCallback onFavoriteTap;

// //   @override
// //   Widget build(BuildContext context) {
// //     final isDark = Theme.of(context).brightness == Brightness.dark;

// //     return InkWell(
// //       borderRadius: BorderRadius.circular(22),
// //       onTap: onTap,
// //       child: Ink(
// //         decoration: BoxDecoration(
// //           color: isDark ? const Color(0xFF10241C) : Colors.white,
// //           borderRadius: BorderRadius.circular(22),
// //           border: Border.all(
// //             color: isDark ? Colors.white.withOpacity(.08) : AppColors.border,
// //           ),
// //           boxShadow: const [
// //             BoxShadow(
// //               color: Color(0x12006B48),
// //               blurRadius: 18,
// //               offset: Offset(0, 8),
// //             ),
// //           ],
// //         ),
// //         padding: const EdgeInsets.all(14),
// //         child: Row(
// //           children: [
// //             Container(
// //               width: 58,
// //               height: 58,
// //               decoration: BoxDecoration(
// //                 color: isDark
// //                     ? Colors.white.withOpacity(.08)
// //                     : const Color(0xFFE8F8F0),
// //                 borderRadius: BorderRadius.circular(18),
// //               ),
// //               child: const Icon(
// //                 Icons.local_post_office_rounded,
// //                 color: AppColors.green,
// //                 size: 30,
// //               ),
// //             ),
// //             const SizedBox(width: 12),
// //             Expanded(
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(
// //                     entry.name,
// //                     maxLines: 1,
// //                     overflow: TextOverflow.ellipsis,
// //                     style: const TextStyle(
// //                       fontSize: 16,
// //                       fontWeight: FontWeight.w900,
// //                     ),
// //                   ),
// //                   const SizedBox(height: 4),
// //                   Text(
// //                     entry.region,
// //                     maxLines: 1,
// //                     overflow: TextOverflow.ellipsis,
// //                     style: const TextStyle(
// //                       color: AppColors.greyText,
// //                       fontWeight: FontWeight.w600,
// //                     ),
// //                   ),
// //                   if (entry.description.trim().isNotEmpty) ...[
// //                     const SizedBox(height: 4),
// //                     Text(
// //                       entry.description,
// //                       maxLines: 1,
// //                       overflow: TextOverflow.ellipsis,
// //                       style: const TextStyle(color: Color(0xFF8A9A93)),
// //                     ),
// //                   ],
// //                 ],
// //               ),
// //             ),
// //             const SizedBox(width: 8),
// //             Column(
// //               children: [
// //                 IconButton(
// //                   tooltip: isFavorite ? 'إزالة من المفضلة' : 'إضافة للمفضلة',
// //                   onPressed: onFavoriteTap,
// //                   icon: Icon(
// //                     isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
// //                     color: isFavorite ? Colors.amber : AppColors.greyText,
// //                   ),
// //                 ),
// //                 Container(
// //                   padding: const EdgeInsets.symmetric(
// //                     horizontal: 10,
// //                     vertical: 7,
// //                   ),
// //                   decoration: BoxDecoration(
// //                     color: AppColors.darkGreen,
// //                     borderRadius: BorderRadius.circular(14),
// //                   ),
// //                   child: Text(
// //                     entry.cisco,
// //                     textDirection: TextDirection.ltr,
// //                     style: const TextStyle(
// //                       color: Colors.white,
// //                       fontWeight: FontWeight.w900,
// //                       letterSpacing: .5,
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // void showCiscoDetails({
// //   required BuildContext context,
// //   required CiscoEntry entry,
// //   required bool isFavorite,
// //   required VoidCallback onToggleFavorite,
// // }) {
// //   showModalBottomSheet<void>(
// //     context: context,
// //     showDragHandle: true,
// //     isScrollControlled: true,
// //     backgroundColor: Theme.of(context).colorScheme.surface,
// //     shape: const RoundedRectangleBorder(
// //       borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
// //     ),
// //     builder: (context) {
// //       return Directionality(
// //         textDirection: TextDirection.rtl,
// //         child: Padding(
// //           padding: EdgeInsets.only(
// //             left: 22,
// //             right: 22,
// //             top: 4,
// //             bottom: MediaQuery.of(context).padding.bottom + 22,
// //           ),
// //           child: SingleChildScrollView(
// //             child: Column(
// //               mainAxisSize: MainAxisSize.min,
// //               crossAxisAlignment: CrossAxisAlignment.stretch,
// //               children: [
// //                 Row(
// //                   children: [
// //                     const _LogoMark(size: 54),
// //                     const SizedBox(width: 12),
// //                     Expanded(
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text(
// //                             entry.name,
// //                             style: const TextStyle(
// //                               fontSize: 22,
// //                               fontWeight: FontWeight.w900,
// //                             ),
// //                           ),
// //                           Text(
// //                             entry.region,
// //                             style: const TextStyle(
// //                               color: AppColors.greyText,
// //                               fontWeight: FontWeight.w600,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                     IconButton.filledTonal(
// //                       onPressed: onToggleFavorite,
// //                       icon: Icon(
// //                         isFavorite
// //                             ? Icons.star_rounded
// //                             : Icons.star_border_rounded,
// //                         color: isFavorite ? Colors.amber : null,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 18),
// //                 _InfoTile(
// //                   label: 'رقم السيسكو',
// //                   value: entry.cisco,
// //                   isNumber: true,
// //                 ),
// //                 _InfoTile(
// //                   label: 'الوصف / الوظيفة',
// //                   value: entry.description,
// //                 ),
// //                 if (entry.notes.trim().isNotEmpty)
// //                   _InfoTile(label: 'ملاحظات', value: entry.notes),
// //                 const SizedBox(height: 12),
// //                 Container(
// //                   padding: const EdgeInsets.all(16),
// //                   decoration: BoxDecoration(
// //                     color: Theme.of(context).brightness == Brightness.dark
// //                         ? Colors.white.withOpacity(.04)
// //                         : const Color(0xFFF4FBF7),
// //                     borderRadius: BorderRadius.circular(22),
// //                     border: Border.all(
// //                       color: Theme.of(context).brightness == Brightness.dark
// //                           ? Colors.white.withOpacity(.08)
// //                           : AppColors.border,
// //                     ),
// //                   ),
// //                   child: Column(
// //                     children: [
// //                       const Text(
// //                         'QR Code لرقم السيسكو',
// //                         style: TextStyle(fontWeight: FontWeight.w900),
// //                       ),
// //                       const SizedBox(height: 12),
// //                       Container(
// //                         color: Colors.white,
// //                         padding: const EdgeInsets.all(12),
// //                         child: QrImageView(
// //                           data: entry.cisco,
// //                           version: QrVersions.auto,
// //                           size: 150,
// //                           backgroundColor: Colors.white,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 const SizedBox(height: 16),
// //                 Row(
// //                   children: [
// //                     Expanded(
// //                       child: FilledButton.icon(
// //                         onPressed: () {
// //                           Clipboard.setData(ClipboardData(text: entry.cisco));
// //                           Navigator.pop(context);
// //                           ScaffoldMessenger.of(context).showSnackBar(
// //                             SnackBar(
// //                               content: Text(
// //                                 'تم نسخ رقم السيسكو: ${entry.cisco}',
// //                               ),
// //                               behavior: SnackBarBehavior.floating,
// //                             ),
// //                           );
// //                         },
// //                         icon: const Icon(Icons.copy_rounded),
// //                         label: const Text('نسخ'),
// //                       ),
// //                     ),
// //                     const SizedBox(width: 10),
// //                     Expanded(
// //                       child: FilledButton.tonalIcon(
// //                         onPressed: () => Share.share(entry.shareText),
// //                         icon: const Icon(Icons.share_rounded),
// //                         label: const Text('مشاركة'),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       );
// //     },
// //   );
// // }

// // class CardsHubScreen extends StatelessWidget {
// //   const CardsHubScreen({
// //     super.key,
// //     required this.all,
// //     required this.regions,
// //     required this.favoritesCount,
// //     required this.recentSearches,
// //     required this.onOpenSearch,
// //   });

// //   final List<CiscoEntry> all;
// //   final List<String> regions;
// //   final int favoritesCount;
// //   final List<String> recentSearches;
// //   final void Function({
// //     String? query,
// //     String? type,
// //     String? region,
// //   }) onOpenSearch;

// //   int _countType(String type) {
// //     if (type == 'مكاتب البريد') {
// //       return all.where((e) => e.description.contains('مكتب بريد')).length;
// //     }
// //     if (type == 'مناطق التوزيع') {
// //       return all
// //           .where(
// //             (e) =>
// //                 e.region.contains('مناطق التوزيع') ||
// //                 e.description.contains('توزيع'),
// //           )
// //           .length;
// //     }
// //     if (type == 'القطاعات') {
// //       return all.where((e) => e.region.contains('القطاعات')).length;
// //     }
// //     return all.length;
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final cards = [
// //       _HubCardData(
// //         title: 'كل الأرقام',
// //         subtitle: '${all.length} رقم متاح',
// //         icon: Icons.dialpad_rounded,
// //         color: AppColors.green,
// //         onTap: () => onOpenSearch(type: 'الكل'),
// //       ),
// //       _HubCardData(
// //         title: 'مكاتب البريد',
// //         subtitle: '${_countType('مكاتب البريد')} نتيجة',
// //         icon: Icons.local_post_office_rounded,
// //         color: const Color(0xFF0E8FD8),
// //         onTap: () => onOpenSearch(type: 'مكاتب البريد'),
// //       ),
// //       _HubCardData(
// //         title: 'مناطق التوزيع',
// //         subtitle: '${_countType('مناطق التوزيع')} نتيجة',
// //         icon: Icons.local_shipping_rounded,
// //         color: const Color(0xFFE09022),
// //         onTap: () => onOpenSearch(type: 'مناطق التوزيع'),
// //       ),
// //       _HubCardData(
// //         title: 'القطاعات',
// //         subtitle: '${_countType('القطاعات')} نتيجة',
// //         icon: Icons.account_tree_rounded,
// //         color: const Color(0xFF7B61FF),
// //         onTap: () => onOpenSearch(type: 'القطاعات'),
// //       ),
// //       _HubCardData(
// //         title: 'المفضلة',
// //         subtitle: '$favoritesCount رقم محفوظ',
// //         icon: Icons.star_rounded,
// //         color: Colors.amber,
// //         onTap: () => onOpenSearch(query: ''),
// //       ),
// //       _HubCardData(
// //         title: 'آخر بحث',
// //         subtitle:
// //             recentSearches.isEmpty ? 'لا يوجد بحث بعد' : recentSearches.first,
// //         icon: Icons.history_rounded,
// //         color: const Color(0xFF546E7A),
// //         onTap: () {
// //           if (recentSearches.isNotEmpty) {
// //             onOpenSearch(query: recentSearches.first);
// //           } else {
// //             onOpenSearch();
// //           }
// //         },
// //       ),
// //     ];

// //     return Scaffold(
// //       appBar: AppBar(title: const Text('الأقسام السريعة')),
// //       body: CustomScrollView(
// //         slivers: [
// //           SliverToBoxAdapter(
// //             child: Container(
// //               margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
// //               padding: const EdgeInsets.all(20),
// //               decoration: BoxDecoration(
// //                 gradient: const LinearGradient(
// //                   begin: Alignment.topRight,
// //                   end: Alignment.bottomLeft,
// //                   colors: [AppColors.green, AppColors.darkGreen],
// //                 ),
// //                 borderRadius: BorderRadius.circular(28),
// //               ),
// //               child: Row(
// //                 children: [
// //                   const _LogoMark(size: 68),
// //                   const SizedBox(width: 14),
// //                   Expanded(
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         const Text(
// //                           'من تبحث عنه اليوم؟',
// //                           style: TextStyle(
// //                             color: Colors.white,
// //                             fontSize: 22,
// //                             fontWeight: FontWeight.w900,
// //                           ),
// //                         ),
// //                         const SizedBox(height: 6),
// //                         Text(
// //                           'اختار القسم وابدأ أسرع بدل الدوران في القوائم كأنها متاهة حكومية.',
// //                           style: TextStyle(
// //                             color: Colors.white.withOpacity(.82),
// //                             height: 1.4,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //           SliverPadding(
// //             padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
// //             sliver: SliverGrid.builder(
// //               itemCount: cards.length,
// //               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //                 crossAxisCount: 2,
// //                 mainAxisExtent: 155,
// //                 mainAxisSpacing: 12,
// //                 crossAxisSpacing: 12,
// //               ),
// //               itemBuilder: (context, index) {
// //                 final card = cards[index];

// //                 return _HubCard(data: card);
// //               },
// //             ),
// //           ),
// //           SliverToBoxAdapter(
// //             child: Padding(
// //               padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
// //               child: FilledButton.icon(
// //                 onPressed: () => onOpenSearch(),
// //                 icon: const Icon(Icons.search_rounded),
// //                 label: const Text('فتح البحث السريع'),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class _HubCardData {
// //   _HubCardData({
// //     required this.title,
// //     required this.subtitle,
// //     required this.icon,
// //     required this.color,
// //     required this.onTap,
// //   });

// //   final String title;
// //   final String subtitle;
// //   final IconData icon;
// //   final Color color;
// //   final VoidCallback onTap;
// // }

// // class _HubCard extends StatelessWidget {
// //   const _HubCard({required this.data});

// //   final _HubCardData data;

// //   @override
// //   Widget build(BuildContext context) {
// //     final isDark = Theme.of(context).brightness == Brightness.dark;

// //     return InkWell(
// //       borderRadius: BorderRadius.circular(26),
// //       onTap: data.onTap,
// //       child: Ink(
// //         decoration: BoxDecoration(
// //           color: isDark ? const Color(0xFF10241C) : Colors.white,
// //           borderRadius: BorderRadius.circular(26),
// //           border: Border.all(
// //             color: isDark ? Colors.white.withOpacity(.08) : AppColors.border,
// //           ),
// //           boxShadow: const [
// //             BoxShadow(
// //               color: Color(0x10006B48),
// //               blurRadius: 18,
// //               offset: Offset(0, 9),
// //             ),
// //           ],
// //         ),
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Container(
// //               width: 48,
// //               height: 48,
// //               decoration: BoxDecoration(
// //                 color: data.color.withOpacity(.13),
// //                 borderRadius: BorderRadius.circular(16),
// //               ),
// //               child: Icon(data.icon, color: data.color, size: 28),
// //             ),
// //             const Spacer(),
// //             Text(
// //               data.title,
// //               style: const TextStyle(
// //                 fontSize: 17,
// //                 fontWeight: FontWeight.w900,
// //               ),
// //             ),
// //             const SizedBox(height: 4),
// //             Text(
// //               data.subtitle,
// //               maxLines: 1,
// //               overflow: TextOverflow.ellipsis,
// //               style: const TextStyle(color: AppColors.greyText),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class FavoritesScreen extends StatelessWidget {
// //   const FavoritesScreen({
// //     super.key,
// //     required this.all,
// //     required this.favorites,
// //     required this.onToggleFavorite,
// //     required this.onOpenDetails,
// //   });

// //   final List<CiscoEntry> all;
// //   final Set<int> favorites;
// //   final Future<void> Function(CiscoEntry entry) onToggleFavorite;
// //   final void Function(CiscoEntry entry) onOpenDetails;

// //   @override
// //   Widget build(BuildContext context) {
// //     final items = all.where((e) => favorites.contains(e.id)).toList();

// //     return Scaffold(
// //       appBar: AppBar(title: const Text('المفضلة')),
// //       body: items.isEmpty
// //           ? const _FavoritesEmpty()
// //           : ListView.separated(
// //               padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
// //               itemCount: items.length,
// //               separatorBuilder: (_, __) => const SizedBox(height: 10),
// //               itemBuilder: (context, index) {
// //                 final item = items[index];

// //                 return _ResultCard(
// //                   entry: item,
// //                   isFavorite: true,
// //                   onTap: () => onOpenDetails(item),
// //                   onFavoriteTap: () => onToggleFavorite(item),
// //                 );
// //               },
// //             ),
// //     );
// //   }
// // }

// // class _FavoritesEmpty extends StatelessWidget {
// //   const _FavoritesEmpty();

// //   @override
// //   Widget build(BuildContext context) {
// //     return const Center(
// //       child: Padding(
// //         padding: EdgeInsets.all(28),
// //         child: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             Icon(Icons.star_border_rounded, size: 72, color: AppColors.green),
// //             SizedBox(height: 14),
// //             Text(
// //               'لا توجد أرقام في المفضلة',
// //               style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
// //             ),
// //             SizedBox(height: 8),
// //             Text(
// //               'اضغط على علامة النجمة بجانب أي نتيجة لحفظها هنا.',
// //               textAlign: TextAlign.center,
// //               style: TextStyle(color: AppColors.greyText),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class SettingsScreen extends StatelessWidget {
// //   const SettingsScreen({
// //     super.key,
// //     required this.total,
// //     required this.favoritesCount,
// //     required this.recentCount,
// //     required this.onClearRecent,
// //   });

// //   final int total;
// //   final int favoritesCount;
// //   final int recentCount;
// //   final VoidCallback onClearRecent;

// //   @override
// //   Widget build(BuildContext context) {
// //     final settings = AppSettingsScope.of(context);

// //     return Scaffold(
// //       appBar: AppBar(title: const Text('الإعدادات')),
// //       body: ListView(
// //         padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
// //         children: [
// //           Container(
// //             padding: const EdgeInsets.all(20),
// //             decoration: BoxDecoration(
// //               gradient: const LinearGradient(
// //                 begin: Alignment.topRight,
// //                 end: Alignment.bottomLeft,
// //                 colors: [AppColors.green, AppColors.darkGreen],
// //               ),
// //               borderRadius: BorderRadius.circular(28),
// //             ),
// //             child: const Column(
// //               children: [
// //                 _LogoMark(size: 86),
// //                 SizedBox(height: 16),
// //                 Text(
// //                   'Egypt Post Cisco',
// //                   textDirection: TextDirection.ltr,
// //                   style: TextStyle(
// //                     color: Colors.white,
// //                     fontSize: 24,
// //                     fontWeight: FontWeight.w900,
// //                   ),
// //                 ),
// //                 SizedBox(height: 8),
// //                 Text(
// //                   'تطبيق داخلي لتسهيل الوصول إلى أرقام السيسكو الخاصة بجهات البريد المصري.',
// //                   textAlign: TextAlign.center,
// //                   style: TextStyle(color: Colors.white, height: 1.5),
// //                 ),
// //                 SizedBox(height: 12),
// //                 Text(
// //                   'هدية من إدارة التكنولوجيا والمعلومات بمنطقة برج العرب إلى جميع موظفي البريد المصري.',
// //                   textAlign: TextAlign.center,
// //                   style: TextStyle(
// //                     color: Colors.white,
// //                     height: 1.5,
// //                     fontWeight: FontWeight.w800,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           const SizedBox(height: 16),
// //           SwitchListTile(
// //             value: settings.isDarkMode,
// //             onChanged: settings.onThemeChanged,
// //             secondary: const Icon(Icons.dark_mode_rounded),
// //             title: const Text(
// //               'الوضع الليلي',
// //               style: TextStyle(fontWeight: FontWeight.w900),
// //             ),
// //             subtitle: const Text('تغيير شكل التطبيق للعرض الليلي.'),
// //           ),
// //           const Divider(),
// //           _SettingsTile(
// //             icon: Icons.dialpad_rounded,
// //             title: 'إجمالي الأرقام',
// //             value: '$total',
// //           ),
// //           _SettingsTile(
// //             icon: Icons.star_rounded,
// //             title: 'الأرقام المفضلة',
// //             value: '$favoritesCount',
// //           ),
// //           _SettingsTile(
// //             icon: Icons.history_rounded,
// //             title: 'آخر عمليات البحث',
// //             value: '$recentCount',
// //           ),
// //           const SizedBox(height: 8),
// //           FilledButton.tonalIcon(
// //             onPressed: onClearRecent,
// //             icon: const Icon(Icons.delete_sweep_rounded),
// //             label: const Text('مسح آخر عمليات البحث'),
// //           ),
// //           const SizedBox(height: 14),
// //           const Text(
// //             'تنبيه: البيانات للاستخدام الداخلي، وتعتمد دقتها على آخر ملف تم إضافته داخل التطبيق.',
// //             textAlign: TextAlign.center,
// //             style: TextStyle(color: AppColors.greyText, height: 1.5),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class _SettingsTile extends StatelessWidget {
// //   const _SettingsTile({
// //     required this.icon,
// //     required this.title,
// //     required this.value,
// //   });

// //   final IconData icon;
// //   final String title;
// //   final String value;

// //   @override
// //   Widget build(BuildContext context) {
// //     return ListTile(
// //       leading: Icon(icon, color: AppColors.green),
// //       title: Text(
// //         title,
// //         style: const TextStyle(fontWeight: FontWeight.w800),
// //       ),
// //       trailing: Text(
// //         value,
// //         style: const TextStyle(
// //           fontWeight: FontWeight.w900,
// //           fontSize: 16,
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class _InfoTile extends StatelessWidget {
// //   const _InfoTile({
// //     required this.label,
// //     required this.value,
// //     this.isNumber = false,
// //   });

// //   final String label;
// //   final String value;
// //   final bool isNumber;

// //   @override
// //   Widget build(BuildContext context) {
// //     final isDark = Theme.of(context).brightness == Brightness.dark;

// //     return Container(
// //       margin: const EdgeInsets.only(bottom: 10),
// //       padding: const EdgeInsets.all(14),
// //       decoration: BoxDecoration(
// //         color: isDark ? Colors.white.withOpacity(.04) : AppColors.paleGreen,
// //         borderRadius: BorderRadius.circular(18),
// //         border: Border.all(
// //           color: isDark ? Colors.white.withOpacity(.08) : AppColors.border,
// //         ),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text(
// //             label,
// //             style: const TextStyle(
// //               color: AppColors.greyText,
// //               fontWeight: FontWeight.bold,
// //               fontSize: 12,
// //             ),
// //           ),
// //           const SizedBox(height: 5),
// //           Text(
// //             value.isEmpty ? '-' : value,
// //             textDirection: isNumber ? TextDirection.ltr : TextDirection.rtl,
// //             style: TextStyle(
// //               fontSize: isNumber ? 26 : 16,
// //               fontWeight: FontWeight.w900,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class _LogoMark extends StatelessWidget {
// //   const _LogoMark({required this.size});

// //   final double size;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       width: size,
// //       height: size,
// //       padding: const EdgeInsets.all(5),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         shape: BoxShape.circle,
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(.12),
// //             blurRadius: 14,
// //             offset: const Offset(0, 6),
// //           ),
// //         ],
// //       ),
// //       child: ClipOval(
// //         child: Image.asset(
// //           'assets/images/egypt_post_logo.png',
// //           fit: BoxFit.cover,
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class _StatPill extends StatelessWidget {
// //   const _StatPill({
// //     required this.icon,
// //     required this.label,
// //     required this.value,
// //   });

// //   final IconData icon;
// //   final String label;
// //   final String value;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(
// //         horizontal: 12,
// //         vertical: 10,
// //       ),
// //       decoration: BoxDecoration(
// //         color: Colors.white.withOpacity(.16),
// //         borderRadius: BorderRadius.circular(18),
// //         border: Border.all(color: Colors.white.withOpacity(.22)),
// //       ),
// //       child: Row(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           Icon(icon, color: Colors.white, size: 20),
// //           const SizedBox(width: 8),
// //           Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Text(
// //                 value,
// //                 style: const TextStyle(
// //                   color: Colors.white,
// //                   fontWeight: FontWeight.w900,
// //                   fontSize: 15,
// //                 ),
// //               ),
// //               Text(
// //                 label,
// //                 style: TextStyle(
// //                   color: Colors.white.withOpacity(.82),
// //                   fontSize: 11,
// //                   fontWeight: FontWeight.w600,
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class _EmptyState extends StatelessWidget {
// //   const _EmptyState({required this.onReset});

// //   final VoidCallback onReset;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Center(
// //       child: Padding(
// //         padding: const EdgeInsets.all(28),
// //         child: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             Image.asset(
// //               'assets/images/egypt_post_logo.png',
// //               width: 92,
// //               height: 92,
// //             ),
// //             const SizedBox(height: 18),
// //             const Text(
// //               'لا توجد نتائج مطابقة',
// //               style: TextStyle(
// //                 fontSize: 20,
// //                 fontWeight: FontWeight.w900,
// //               ),
// //             ),
// //             const SizedBox(height: 8),
// //             const Text(
// //               'جرّب البحث بجزء من الاسم، أو رقم السيسكو مباشرة، أو اختر كل المناطق.',
// //               textAlign: TextAlign.center,
// //               style: TextStyle(color: AppColors.greyText),
// //             ),
// //             const SizedBox(height: 14),
// //             FilledButton.tonalIcon(
// //               onPressed: onReset,
// //               icon: const Icon(Icons.refresh_rounded),
// //               label: const Text('إعادة ضبط البحث'),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class _OnboardingItem extends StatelessWidget {
// //   const _OnboardingItem({
// //     required this.icon,
// //     required this.title,
// //     required this.text,
// //   });

// //   final IconData icon;
// //   final String title;
// //   final String text;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Row(
// //       children: [
// //         Icon(icon, color: AppColors.green),
// //         const SizedBox(width: 10),
// //         Expanded(
// //           child: RichText(
// //             text: TextSpan(
// //               style: DefaultTextStyle.of(context).style,
// //               children: [
// //                 TextSpan(
// //                   text: '$title\n',
// //                   style: const TextStyle(fontWeight: FontWeight.w900),
// //                 ),
// //                 TextSpan(
// //                   text: text,
// //                   style: const TextStyle(
// //                     color: AppColors.greyText,
// //                     height: 1.4,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }

// // class _SearchHeaderDelegate extends SliverPersistentHeaderDelegate {
// //   _SearchHeaderDelegate({
// //     required this.child,
// //     required this.minHeight,
// //     required this.maxHeight,
// //   });

// //   final Widget child;
// //   final double minHeight;
// //   final double maxHeight;

// //   @override
// //   double get minExtent => minHeight;

// //   @override
// //   double get maxExtent => maxHeight;

// //   @override
// //   Widget build(
// //     BuildContext context,
// //     double shrinkOffset,
// //     bool overlapsContent,
// //   ) {
// //     return child;
// //   }

// //   @override
// //   bool shouldRebuild(covariant _SearchHeaderDelegate oldDelegate) {
// //     return oldDelegate.child != child ||
// //         oldDelegate.minHeight != minHeight ||
// //         oldDelegate.maxHeight != maxHeight;
// //   }
// // }

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const EgyptPostCiscoApp());
// }

// class EgyptPostCiscoApp extends StatefulWidget {
//   const EgyptPostCiscoApp({super.key});

//   @override
//   State<EgyptPostCiscoApp> createState() => _EgyptPostCiscoAppState();
// }

// class _EgyptPostCiscoAppState extends State<EgyptPostCiscoApp> {
//   ThemeMode _themeMode = ThemeMode.light;

//   static const Color seed = Color(0xFF07965F);

//   @override
//   void initState() {
//     super.initState();
//     _loadThemeMode();
//   }

//   Future<void> _loadThemeMode() async {
//     final prefs = await SharedPreferences.getInstance();
//     final isDark = prefs.getBool(AppPrefs.darkModeKey) ?? false;
//     setState(() {
//       _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
//     });
//   }

//   Future<void> _toggleTheme(bool value) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool(AppPrefs.darkModeKey, value);
//     setState(() {
//       _themeMode = value ? ThemeMode.dark : ThemeMode.light;
//     });
//   }

//   ThemeData _lightTheme() {
//     return ThemeData(
//       useMaterial3: true,
//       brightness: Brightness.light,
//       colorScheme: ColorScheme.fromSeed(
//         seedColor: seed,
//         primary: seed,
//         secondary: const Color(0xFF013F2B),
//         surface: const Color(0xFFF4FBF7),
//       ),
//       scaffoldBackgroundColor: const Color(0xFFF4FBF7),
//       fontFamily: 'Arial',
//       appBarTheme: const AppBarTheme(
//         centerTitle: true,
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         foregroundColor: Color(0xFF003D2A),
//       ),
//       inputDecorationTheme: InputDecorationTheme(
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(22),
//           borderSide: BorderSide.none,
//         ),
//       ),
//     );
//   }

//   ThemeData _darkTheme() {
//     return ThemeData(
//       useMaterial3: true,
//       brightness: Brightness.dark,
//       colorScheme: ColorScheme.fromSeed(
//         brightness: Brightness.dark,
//         seedColor: seed,
//         primary: seed,
//         secondary: const Color(0xFF22C483),
//         surface: const Color(0xFF10241C),
//       ),
//       scaffoldBackgroundColor: const Color(0xFF071A13),
//       fontFamily: 'Arial',
//       appBarTheme: const AppBarTheme(
//         centerTitle: true,
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       inputDecorationTheme: InputDecorationTheme(
//         filled: true,
//         fillColor: const Color(0xFF10241C),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(22),
//           borderSide: BorderSide.none,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AppSettingsScope(
//       isDarkMode: _themeMode == ThemeMode.dark,
//       onThemeChanged: _toggleTheme,
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'Egypt Post Cisco',
//         theme: _lightTheme(),
//         darkTheme: _darkTheme(),
//         themeMode: _themeMode,
//         home: const Directionality(
//           textDirection: TextDirection.rtl,
//           child: SplashScreen(),
//         ),
//       ),
//     );
//   }
// }

// class AppPrefs {
//   static const String favoritesKey = 'favorite_cisco_ids';
//   static const String recentSearchesKey = 'recent_searches';
//   static const String onboardingDoneKey = 'onboarding_done';
//   static const String darkModeKey = 'dark_mode_enabled';
// }

// class AppSettingsScope extends InheritedWidget {
//   const AppSettingsScope({
//     super.key,
//     required super.child,
//     required this.isDarkMode,
//     required this.onThemeChanged,
//   });

//   final bool isDarkMode;
//   final ValueChanged<bool> onThemeChanged;

//   static AppSettingsScope of(BuildContext context) {
//     final scope =
//         context.dependOnInheritedWidgetOfExactType<AppSettingsScope>();
//     assert(scope != null, 'AppSettingsScope not found');
//     return scope!;
//   }

//   @override
//   bool updateShouldNotify(AppSettingsScope oldWidget) {
//     return oldWidget.isDarkMode != isDarkMode;
//   }
// }

// class AppColors {
//   static const green = Color(0xFF07965F);
//   static const darkGreen = Color(0xFF003D2A);
//   static const midGreen = Color(0xFF006B48);
//   static const paleGreen = Color(0xFFF4FBF7);
//   static const border = Color(0xFFE2F1EA);
//   static const greyText = Color(0xFF70877E);
// }

// class CiscoEntry {
//   CiscoEntry({
//     required this.id,
//     required this.region,
//     required this.name,
//     required this.description,
//     required this.cisco,
//     required this.notes,
//   });

//   final int id;
//   final String region;
//   final String name;
//   final String description;
//   final String cisco;
//   final String notes;

//   factory CiscoEntry.fromJson(Map<String, dynamic> json) {
//     return CiscoEntry(
//       id: json['id'] as int,
//       region: json['region'] as String? ?? '',
//       name: json['name'] as String? ?? '',
//       description: json['description'] as String? ?? '',
//       cisco: json['cisco'] as String? ?? '',
//       notes: json['notes'] as String? ?? '',
//     );
//   }

//   String get shareText {
//     return '''
// Egypt Post Cisco

// الاسم: $name
// المنطقة: $region
// الوصف: ${description.isEmpty ? '-' : description}
// رقم السيسكو: $cisco
// ''';
//   }
// }

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _controller;
//   late final Animation<double> _fadeAnimation;
//   late final Animation<double> _scaleAnimation;
//   late final Animation<Offset> _slideAnimation;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1800),
//     );

//     _fadeAnimation = CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeOut,
//     );

//     _scaleAnimation = Tween<double>(begin: .82, end: 1).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
//     );

//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, .18),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
//     );

//     _controller.forward();

//     Future.delayed(const Duration(seconds: 4), () {
//       if (!mounted) return;

//       Navigator.of(context).pushReplacement(
//         PageRouteBuilder(
//           transitionDuration: const Duration(milliseconds: 850),
//           pageBuilder: (_, animation, __) {
//             return FadeTransition(
//               opacity: animation,
//               child: const Directionality(
//                 textDirection: TextDirection.rtl,
//                 child: MainShell(),
//               ),
//             );
//           },
//         ),
//       );
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   Widget _backgroundLogo({
//     required double size,
//     required double opacity,
//   }) {
//     return Opacity(
//       opacity: opacity,
//       child: Image.asset(
//         'assets/images/egypt_post_logo.png',
//         width: size,
//         height: size,
//         fit: BoxFit.cover,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: AnnotatedRegion<SystemUiOverlayStyle>(
//         value: SystemUiOverlayStyle.light,
//         child: Container(
//           width: double.infinity,
//           height: double.infinity,
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topRight,
//               end: Alignment.bottomLeft,
//               colors: [
//                 AppColors.green,
//                 AppColors.midGreen,
//                 AppColors.darkGreen,
//               ],
//             ),
//           ),
//           child: Stack(
//             children: [
//               PositionedDirectional(
//                 top: -95,
//                 end: -75,
//                 child: _backgroundLogo(size: 285, opacity: .09),
//               ),
//               PositionedDirectional(
//                 bottom: -110,
//                 start: -90,
//                 child: _backgroundLogo(size: 320, opacity: .075),
//               ),
//               PositionedDirectional(
//                 top: MediaQuery.of(context).padding.top + 34,
//                 start: 26,
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 14,
//                     vertical: 8,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(.13),
//                     borderRadius: BorderRadius.circular(100),
//                     border: Border.all(color: Colors.white.withOpacity(.22)),
//                   ),
//                   child: const Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(Icons.security_rounded,
//                           color: Colors.white, size: 18),
//                       SizedBox(width: 7),
//                       Text(
//                         'منطقة برج العرب',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w800,
//                           fontSize: 13,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Center(
//                 child: FadeTransition(
//                   opacity: _fadeAnimation,
//                   child: SlideTransition(
//                     position: _slideAnimation,
//                     child: ScaleTransition(
//                       scale: _scaleAnimation,
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 26),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Container(
//                               width: 144,
//                               height: 144,
//                               padding: const EdgeInsets.all(8),
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 shape: BoxShape.circle,
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(.25),
//                                     blurRadius: 32,
//                                     offset: const Offset(0, 16),
//                                   ),
//                                 ],
//                               ),
//                               child: ClipOval(
//                                 child: Image.asset(
//                                   'assets/images/egypt_post_logo.png',
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 28),
//                             const Text(
//                               'Egypt Post Cisco',
//                               textDirection: TextDirection.ltr,
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 31,
//                                 fontWeight: FontWeight.w900,
//                                 letterSpacing: .4,
//                               ),
//                             ),
//                             const SizedBox(height: 9),
//                             Text(
//                               'دليل أرقام السيسكو للبريد المصري',
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 color: Colors.white.withOpacity(.88),
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                             const SizedBox(height: 34),
//                             Container(
//                               width: double.infinity,
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 20,
//                                 vertical: 23,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: Colors.white.withOpacity(.14),
//                                 borderRadius: BorderRadius.circular(28),
//                                 border: Border.all(
//                                   color: Colors.white.withOpacity(.24),
//                                 ),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(.10),
//                                     blurRadius: 24,
//                                     offset: const Offset(0, 12),
//                                   ),
//                                 ],
//                               ),
//                               child: Column(
//                                 children: [
//                                   Container(
//                                     width: 48,
//                                     height: 5,
//                                     decoration: BoxDecoration(
//                                       color: Colors.white.withOpacity(.55),
//                                       borderRadius: BorderRadius.circular(100),
//                                     ),
//                                   ),
//                                   const SizedBox(height: 18),
//                                   const Text(
//                                     'اهداء من إدارة التكنولوجيا والمعلومات\nبمنطقة برج العرب\nإلى جميع موظفي البريد المصري\n\nتنفيذ : م/ احمد نابغ موسي',
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 17,
//                                       height: 1.55,
//                                       fontWeight: FontWeight.w900,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(height: 34),
//                             SizedBox(
//                               width: 36,
//                               height: 36,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 3,
//                                 valueColor: const AlwaysStoppedAnimation<Color>(
//                                   Colors.white,
//                                 ),
//                                 backgroundColor: Colors.white.withOpacity(.22),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               PositionedDirectional(
//                 bottom: MediaQuery.of(context).padding.bottom + 28,
//                 start: 24,
//                 end: 24,
//                 child: Text(
//                   'Powered by Egypt Post Technology & Information',
//                   textDirection: TextDirection.ltr,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Colors.white.withOpacity(.62),
//                     fontSize: 12,
//                     fontWeight: FontWeight.w600,
//                     letterSpacing: .2,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class MainShell extends StatefulWidget {
//   const MainShell({super.key});

//   @override
//   State<MainShell> createState() => _MainShellState();
// }

// class _MainShellState extends State<MainShell> {
//   int _index = 0;

//   List<CiscoEntry> _all = const [];
//   List<String> _regions = const [];
//   Set<int> _favorites = {};
//   List<String> _recentSearches = [];
//   bool _loading = true;

//   final GlobalKey<CiscoHomePageState> _homeKey =
//       GlobalKey<CiscoHomePageState>();

//   @override
//   void initState() {
//     super.initState();
//     _bootstrap();
//   }

//   Future<void> _bootstrap() async {
//     await Future.wait([
//       _loadData(),
//       _loadFavorites(),
//       _loadRecentSearches(),
//     ]);

//     if (!mounted) return;

//     setState(() => _loading = false);
//     await _showOnboardingIfNeeded();
//   }

//   Future<void> _loadData() async {
//     final raw = await rootBundle.loadString('assets/data/cisco_directory.json');
//     final decoded = jsonDecode(raw) as List<dynamic>;
//     final loaded = decoded
//         .map((e) => CiscoEntry.fromJson(e as Map<String, dynamic>))
//         .toList(growable: false);

//     final regions = loaded.map((e) => e.region).toSet().toList()..sort();

//     _all = loaded;
//     _regions = ['كل المناطق', ...regions];
//   }

//   Future<void> _loadFavorites() async {
//     final prefs = await SharedPreferences.getInstance();
//     final raw = prefs.getStringList(AppPrefs.favoritesKey) ?? [];
//     _favorites = raw.map(int.parse).toSet();
//   }

//   Future<void> _loadRecentSearches() async {
//     final prefs = await SharedPreferences.getInstance();
//     _recentSearches = prefs.getStringList(AppPrefs.recentSearchesKey) ?? [];
//   }

//   Future<void> _saveFavorites() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setStringList(
//       AppPrefs.favoritesKey,
//       _favorites.map((e) => e.toString()).toList(),
//     );
//   }

//   Future<void> _saveRecentSearch(String value) async {
//     final query = value.trim();
//     if (query.isEmpty) return;

//     _recentSearches.removeWhere((e) => e == query);
//     _recentSearches.insert(0, query);

//     if (_recentSearches.length > 10) {
//       _recentSearches = _recentSearches.take(10).toList();
//     }

//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setStringList(AppPrefs.recentSearchesKey, _recentSearches);

//     if (mounted) setState(() {});
//   }

//   Future<void> _clearRecentSearches() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(AppPrefs.recentSearchesKey);
//     setState(() => _recentSearches = []);
//   }

//   Future<void> _showOnboardingIfNeeded() async {
//     final prefs = await SharedPreferences.getInstance();
//     final done = prefs.getBool(AppPrefs.onboardingDoneKey) ?? false;

//     if (done || !mounted) return;

//     await showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => Directionality(
//         textDirection: TextDirection.rtl,
//         child: AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(26),
//           ),
//           title: const Text(
//             'مرحبًا بك في Egypt Post Cisco',
//             style: TextStyle(fontWeight: FontWeight.w900),
//           ),
//           content: const Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               _OnboardingItem(
//                 icon: Icons.search_rounded,
//                 title: 'بحث سريع',
//                 text: 'ابحث بالاسم، المكان، الوظيفة أو رقم السيسكو.',
//               ),
//               SizedBox(height: 12),
//               _OnboardingItem(
//                 icon: Icons.star_rounded,
//                 title: 'المفضلة',
//                 text: 'احفظ الأرقام المهمة للوصول لها بسرعة.',
//               ),
//               SizedBox(height: 12),
//               _OnboardingItem(
//                 icon: Icons.share_rounded,
//                 title: 'مشاركة و QR',
//                 text: 'شارك بيانات الجهة أو اعرض الرقم كـ QR Code.',
//               ),
//             ],
//           ),
//           actions: [
//             FilledButton(
//               onPressed: () async {
//                 await prefs.setBool(AppPrefs.onboardingDoneKey, true);
//                 if (context.mounted) Navigator.pop(context);
//               },
//               child: const Text('ابدأ الآن'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _toggleFavorite(CiscoEntry entry) async {
//     setState(() {
//       if (_favorites.contains(entry.id)) {
//         _favorites.remove(entry.id);
//       } else {
//         _favorites.add(entry.id);
//       }
//     });

//     await _saveFavorites();
//   }

//   void _openSearchWith({
//     String? query,
//     String? type,
//     String? region,
//   }) {
//     setState(() => _index = 0);

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _homeKey.currentState?.setSearchAndFilters(
//         query: query,
//         type: type,
//         region: region,
//       );
//     });
//   }

//   void _openDetails(CiscoEntry entry) {
//     showCiscoDetails(
//       context: context,
//       entry: entry,
//       isFavorite: _favorites.contains(entry.id),
//       onToggleFavorite: () => _toggleFavorite(entry),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_loading) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     final pages = [
//       CiscoHomePage(
//         key: _homeKey,
//         all: _all,
//         regions: _regions,
//         favorites: _favorites,
//         recentSearches: _recentSearches,
//         onSaveRecentSearch: _saveRecentSearch,
//         onClearRecentSearches: _clearRecentSearches,
//         onToggleFavorite: _toggleFavorite,
//         onOpenDetails: _openDetails,
//       ),
//       CardsHubScreen(
//         all: _all,
//         regions: _regions,
//         favoritesCount: _favorites.length,
//         recentSearches: _recentSearches,
//         onOpenSearch: _openSearchWith,
//       ),
//       FavoritesScreen(
//         all: _all,
//         favorites: _favorites,
//         onToggleFavorite: _toggleFavorite,
//         onOpenDetails: _openDetails,
//       ),
//       SettingsScreen(
//         total: _all.length,
//         favoritesCount: _favorites.length,
//         recentCount: _recentSearches.length,
//         recentSearches: _recentSearches,
//         onClearRecent: _clearRecentSearches,
//       ),
//     ];

//     return Scaffold(
//       body: IndexedStack(
//         index: _index,
//         children: pages,
//       ),
//       bottomNavigationBar: NavigationBar(
//         selectedIndex: _index,
//         onDestinationSelected: (value) => setState(() => _index = value),
//         destinations: const [
//           NavigationDestination(
//             icon: Icon(Icons.search_rounded),
//             selectedIcon: Icon(Icons.search_rounded),
//             label: 'البحث',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.dashboard_outlined),
//             selectedIcon: Icon(Icons.dashboard_rounded),
//             label: 'الأقسام',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.star_border_rounded),
//             selectedIcon: Icon(Icons.star_rounded),
//             label: 'المفضلة',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.settings_outlined),
//             selectedIcon: Icon(Icons.settings_rounded),
//             label: 'الإعدادات',
//           ),
//         ],
//       ),
//     );
//   }
// }

// class CiscoHomePage extends StatefulWidget {
//   const CiscoHomePage({
//     super.key,
//     required this.all,
//     required this.regions,
//     required this.favorites,
//     required this.recentSearches,
//     required this.onSaveRecentSearch,
//     required this.onClearRecentSearches,
//     required this.onToggleFavorite,
//     required this.onOpenDetails,
//   });

//   final List<CiscoEntry> all;
//   final List<String> regions;
//   final Set<int> favorites;
//   final List<String> recentSearches;
//   final Future<void> Function(String value) onSaveRecentSearch;
//   final Future<void> Function() onClearRecentSearches;
//   final Future<void> Function(CiscoEntry entry) onToggleFavorite;
//   final void Function(CiscoEntry entry) onOpenDetails;

//   @override
//   State<CiscoHomePage> createState() => CiscoHomePageState();
// }

// class CiscoHomePageState extends State<CiscoHomePage> {
//   final TextEditingController _searchController = TextEditingController();
//   final FocusNode _searchFocus = FocusNode();
//   final stt.SpeechToText _speech = stt.SpeechToText();

//   List<CiscoEntry> _filtered = const [];
//   List<String> _suggestions = const [];

//   String _query = '';
//   String _selectedRegion = 'كل المناطق';
//   String _selectedType = 'الكل';

//   bool _voiceAvailable = false;
//   bool _isListening = false;

//   static const List<String> _types = [
//     'الكل',
//     'مكاتب البريد',
//     'مناطق التوزيع',
//     'القطاعات',
//   ];

//   @override
//   void initState() {
//     super.initState();

//     _filtered = _rankedResults(widget.all, '');

//     _searchController.addListener(() {
//       _query = _searchController.text;
//       _applyFilters();
//       _buildSuggestions();
//     });

//     _initVoice();
//   }

//   Future<void> _initVoice() async {
//     final available = await _speech.initialize();
//     if (!mounted) return;
//     setState(() => _voiceAvailable = available);
//   }

//   Future<void> _startVoiceSearch() async {
//     if (!_voiceAvailable) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('البحث الصوتي غير متاح على هذا الجهاز.'),
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//       return;
//     }

//     if (_isListening) {
//       await _speech.stop();
//       setState(() => _isListening = false);
//       return;
//     }

//     setState(() => _isListening = true);

//     await _speech.listen(
//       localeId: 'ar_EG',
//       listenMode: stt.ListenMode.search,
//       onResult: (result) {
//         final recognized = result.recognizedWords.trim();
//         if (recognized.isNotEmpty) {
//           _searchController.text = recognized;
//           _searchController.selection = TextSelection.collapsed(
//             offset: recognized.length,
//           );
//         }

//         if (result.finalResult) {
//           setState(() => _isListening = false);
//           widget.onSaveRecentSearch(recognized);
//         }
//       },
//     );
//   }

//   void setSearchAndFilters({
//     String? query,
//     String? type,
//     String? region,
//   }) {
//     if (query != null) {
//       _searchController.text = query;
//       _searchController.selection = TextSelection.collapsed(
//         offset: query.length,
//       );
//     }

//     setState(() {
//       if (type != null) _selectedType = type;
//       if (region != null) _selectedRegion = region;
//     });

//     _applyFilters();
//   }

//   String _normalize(String value) {
//     return value
//         .replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '')
//         .replaceAll('أ', 'ا')
//         .replaceAll('إ', 'ا')
//         .replaceAll('آ', 'ا')
//         .replaceAll('ى', 'ي')
//         .replaceAll('ة', 'ه')
//         .replaceAll('ؤ', 'و')
//         .replaceAll('ئ', 'ي')
//         .replaceAll('ٱ', 'ا')
//         .replaceAll(RegExp(r'\s+'), ' ')
//         .replaceAll('برج العرب', 'برجالعرب')
//         .trim()
//         .toLowerCase();
//   }

//   bool _matchesType(CiscoEntry item) {
//     switch (_selectedType) {
//       case 'مكاتب البريد':
//         return item.description.contains('مكتب بريد');
//       case 'مناطق التوزيع':
//         return item.region.contains('مناطق التوزيع') ||
//             item.description.contains('توزيع');
//       case 'القطاعات':
//         return item.region.contains('القطاعات');
//       default:
//         return true;
//     }
//   }

//   int _score(CiscoEntry item, String q) {
//     if (q.isEmpty) return 1;

//     final cisco = _normalize(item.cisco);
//     final name = _normalize(item.name);
//     final region = _normalize(item.region);
//     final description = _normalize(item.description);
//     final notes = _normalize(item.notes);

//     if (cisco == q) return 1000;
//     if (cisco.startsWith(q)) return 900;
//     if (name == q) return 850;
//     if (name.startsWith(q)) return 800;
//     if (name.contains(q)) return 700;
//     if (region.startsWith(q)) return 600;
//     if (region.contains(q)) return 500;
//     if (description.contains(q)) return 400;
//     if (notes.contains(q)) return 300;

//     final haystack = '$name $region $description $cisco $notes';
//     if (haystack.contains(q)) return 100;

//     return 0;
//   }

//   List<CiscoEntry> _rankedResults(List<CiscoEntry> source, String query) {
//     final q = _normalize(query);

//     final scored = source
//         .map((entry) => MapEntry(entry, _score(entry, q)))
//         .where((pair) => q.isEmpty || pair.value > 0)
//         .toList();

//     scored.sort((a, b) => b.value.compareTo(a.value));

//     return scored.map((e) => e.key).toList(growable: false);
//   }

//   void _applyFilters() {
//     final resultSource = widget.all.where((item) {
//       final regionOk =
//           _selectedRegion == 'كل المناطق' || item.region == _selectedRegion;
//       final typeOk = _matchesType(item);
//       return regionOk && typeOk;
//     }).toList();

//     final ranked = _rankedResults(resultSource, _query);

//     setState(() => _filtered = ranked);
//   }

//   void _buildSuggestions() {
//     final q = _normalize(_query);

//     if (q.isEmpty) {
//       setState(() => _suggestions = const []);
//       return;
//     }

//     final names = <String>{};

//     for (final item in widget.all) {
//       final values = [
//         item.name,
//         item.region,
//         item.description,
//         item.cisco,
//       ];

//       for (final value in values) {
//         if (value.trim().isEmpty) continue;
//         if (_normalize(value).contains(q)) {
//           names.add(value.trim());
//         }
//       }

//       if (names.length >= 8) break;
//     }

//     setState(() => _suggestions = names.take(8).toList());
//   }

//   Future<void> _onSearchSubmitted(String value) async {
//     await widget.onSaveRecentSearch(value);
//     _searchFocus.unfocus();
//   }

//   void _openAdvancedFilter() {
//     String tempRegion = _selectedRegion;
//     String tempType = _selectedType;

//     showModalBottomSheet<void>(
//       context: context,
//       showDragHandle: true,
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
//       ),
//       builder: (_) {
//         return Directionality(
//           textDirection: TextDirection.rtl,
//           child: StatefulBuilder(
//             builder: (context, setSheetState) {
//               return Padding(
//                 padding: EdgeInsets.only(
//                   left: 20,
//                   right: 20,
//                   top: 6,
//                   bottom: MediaQuery.of(context).padding.bottom + 22,
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Text(
//                       'فلترة متقدمة',
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.w900,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     DropdownButtonFormField<String>(
//                       value: tempRegion,
//                       isExpanded: true,
//                       items: widget.regions
//                           .map(
//                             (region) => DropdownMenuItem(
//                               value: region,
//                               child: Text(
//                                 region,
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           )
//                           .toList(),
//                       onChanged: (value) {
//                         setSheetState(() {
//                           tempRegion = value ?? 'كل المناطق';
//                         });
//                       },
//                       decoration: const InputDecoration(
//                         labelText: 'المنطقة',
//                         prefixIcon: Icon(Icons.location_on_outlined),
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     DropdownButtonFormField<String>(
//                       value: tempType,
//                       isExpanded: true,
//                       items: _types
//                           .map(
//                             (type) => DropdownMenuItem(
//                               value: type,
//                               child: Text(type),
//                             ),
//                           )
//                           .toList(),
//                       onChanged: (value) {
//                         setSheetState(() {
//                           tempType = value ?? 'الكل';
//                         });
//                       },
//                       decoration: const InputDecoration(
//                         labelText: 'نوع الجهة',
//                         prefixIcon: Icon(Icons.category_outlined),
//                       ),
//                     ),
//                     const SizedBox(height: 18),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: FilledButton.icon(
//                             onPressed: () {
//                               setState(() {
//                                 _selectedRegion = tempRegion;
//                                 _selectedType = tempType;
//                               });
//                               _applyFilters();
//                               Navigator.pop(context);
//                             },
//                             icon: const Icon(Icons.check_rounded),
//                             label: const Text('تطبيق الفلتر'),
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         IconButton.filledTonal(
//                           onPressed: () {
//                             setSheetState(() {
//                               tempRegion = 'كل المناطق';
//                               tempType = 'الكل';
//                             });
//                           },
//                           icon: const Icon(Icons.refresh_rounded),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }

//   void _resetFilters() {
//     _searchController.clear();
//     setState(() {
//       _selectedRegion = 'كل المناطق';
//       _selectedType = 'الكل';
//       _suggestions = const [];
//     });
//     _applyFilters();
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     _searchFocus.dispose();
//     _speech.stop();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () => _searchFocus.requestFocus(),
//         icon: const Icon(Icons.search_rounded),
//         label: const Text('بحث سريع'),
//       ),
//       body: CustomScrollView(
//         slivers: [
//           SliverToBoxAdapter(child: _HeroHeader(total: widget.all.length)),
//           SliverToBoxAdapter(
//             child: SafeArea(
//               top: false,
//               bottom: false,
//               child: _SearchPanel(
//                 controller: _searchController,
//                 focusNode: _searchFocus,
//                 selectedRegion: _selectedRegion,
//                 selectedType: _selectedType,
//                 resultCount: _filtered.length,
//                 suggestions: _suggestions,
//                 recentSearches: widget.recentSearches,
//                 isListening: _isListening,
//                 onVoiceTap: _startVoiceSearch,
//                 onSuggestionTap: (value) {
//                   _searchController.text = value;
//                   _searchController.selection = TextSelection.collapsed(
//                     offset: value.length,
//                   );
//                   widget.onSaveRecentSearch(value);
//                 },
//                 onRecentTap: (value) {
//                   _searchController.text = value;
//                   _searchController.selection = TextSelection.collapsed(
//                     offset: value.length,
//                   );
//                 },
//                 onClearRecent: widget.onClearRecentSearches,
//                 onAdvancedFilter: _openAdvancedFilter,
//                 onReset: _resetFilters,
//                 onSubmitted: _onSearchSubmitted,
//               ),
//             ),
//           ),
//           if (_filtered.isEmpty)
//             SliverFillRemaining(
//               hasScrollBody: false,
//               child: _EmptyState(onReset: _resetFilters),
//             )
//           else
//             SliverPadding(
//               padding: const EdgeInsets.fromLTRB(16, 10, 16, 90),
//               sliver: SliverList.separated(
//                 itemCount: _filtered.length,
//                 separatorBuilder: (_, __) => const SizedBox(height: 10),
//                 itemBuilder: (context, index) {
//                   final item = _filtered[index];

//                   return _ResultCard(
//                     entry: item,
//                     isFavorite: widget.favorites.contains(item.id),
//                     onTap: () => widget.onOpenDetails(item),
//                     onFavoriteTap: () => widget.onToggleFavorite(item),
//                   );
//                 },
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// class _HeroHeader extends StatelessWidget {
//   const _HeroHeader({required this.total});

//   final int total;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.only(
//         top: MediaQuery.of(context).padding.top + 22,
//         left: 18,
//         right: 18,
//         bottom: 22,
//       ),
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topRight,
//           end: Alignment.bottomLeft,
//           colors: [AppColors.green, AppColors.midGreen],
//         ),
//         borderRadius: BorderRadius.vertical(bottom: Radius.circular(34)),
//       ),
//       child: Stack(
//         children: [
//           PositionedDirectional(
//             end: -45,
//             bottom: -55,
//             child: Opacity(
//               opacity: .12,
//               child: Image.asset(
//                 'assets/images/egypt_post_logo.png',
//                 width: 210,
//                 height: 210,
//               ),
//             ),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Row(
//                 children: [
//                   _LogoMark(
//                       size: MediaQuery.of(context).size.width < 370 ? 56 : 72),
//                   const SizedBox(width: 14),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Egypt Post Cisco',
//                           textDirection: TextDirection.ltr,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: MediaQuery.of(context).size.width < 370
//                                 ? 20
//                                 : 24,
//                             fontWeight: FontWeight.w900,
//                             letterSpacing: .3,
//                           ),
//                         ),
//                         Text(
//                           'دليل أرقام السيسكو للبريد المصري',
//                           style: TextStyle(
//                             color: Colors.white.withOpacity(.86),
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),
//               Wrap(
//                 spacing: 10,
//                 runSpacing: 10,
//                 children: [
//                   _StatPill(
//                     icon: Icons.dialpad_rounded,
//                     label: 'رقم محفوظ',
//                     value: '$total+',
//                   ),
//                   const _StatPill(
//                     icon: Icons.public_rounded,
//                     label: 'بحث باسم أو مكان',
//                     value: 'ذكي',
//                   ),
//                   const _StatPill(
//                     icon: Icons.offline_bolt_rounded,
//                     label: 'بدون إنترنت',
//                     value: 'Offline',
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _SearchPanel extends StatelessWidget {
//   const _SearchPanel({
//     required this.controller,
//     required this.focusNode,
//     required this.selectedRegion,
//     required this.selectedType,
//     required this.resultCount,
//     required this.suggestions,
//     required this.recentSearches,
//     required this.isListening,
//     required this.onVoiceTap,
//     required this.onSuggestionTap,
//     required this.onRecentTap,
//     required this.onClearRecent,
//     required this.onAdvancedFilter,
//     required this.onReset,
//     required this.onSubmitted,
//   });

//   final TextEditingController controller;
//   final FocusNode focusNode;
//   final String selectedRegion;
//   final String selectedType;
//   final int resultCount;
//   final List<String> suggestions;
//   final List<String> recentSearches;
//   final bool isListening;
//   final VoidCallback onVoiceTap;
//   final ValueChanged<String> onSuggestionTap;
//   final ValueChanged<String> onRecentTap;
//   final VoidCallback onClearRecent;
//   final VoidCallback onAdvancedFilter;
//   final VoidCallback onReset;
//   final ValueChanged<String> onSubmitted;

//   @override
//   Widget build(BuildContext context) {
//     final visibleChips = suggestions.isNotEmpty ? suggestions : recentSearches;
//     final chipTitle = suggestions.isNotEmpty ? 'اقتراحات' : 'آخر بحث';

//     return Material(
//       color: Theme.of(context).scaffoldBackgroundColor,
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
//         child: Column(
//           children: [
//             TextField(
//               controller: controller,
//               focusNode: focusNode,
//               textInputAction: TextInputAction.search,
//               onSubmitted: onSubmitted,
//               decoration: InputDecoration(
//                 hintText:
//                     'ابحث باسم المكتب، المكان، الوظيفة، أو رقم السيسكو...',
//                 prefixIcon: const Icon(Icons.search_rounded),
//                 suffixIcon: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       tooltip: 'بحث بالصوت',
//                       onPressed: onVoiceTap,
//                       icon: Icon(
//                         isListening
//                             ? Icons.mic_rounded
//                             : Icons.mic_none_rounded,
//                         color: isListening ? Colors.red : null,
//                       ),
//                     ),
//                     if (controller.text.isNotEmpty)
//                       IconButton(
//                         tooltip: 'مسح البحث',
//                         onPressed: controller.clear,
//                         icon: const Icon(Icons.close_rounded),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             Row(
//               children: [
//                 Expanded(
//                   child: FilledButton.tonalIcon(
//                     onPressed: onAdvancedFilter,
//                     icon: const Icon(Icons.tune_rounded),
//                     label: Text(
//                       '$selectedRegion | $selectedType',
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 IconButton.filledTonal(
//                   tooltip: 'إعادة ضبط',
//                   onPressed: onReset,
//                   icon: const Icon(Icons.refresh_rounded),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             if (visibleChips.isNotEmpty) ...[
//               Row(
//                 children: [
//                   Text(
//                     chipTitle,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.w900,
//                       fontSize: 12,
//                     ),
//                   ),
//                   const Spacer(),
//                   if (suggestions.isEmpty && recentSearches.isNotEmpty)
//                     TextButton(
//                       style: TextButton.styleFrom(
//                         minimumSize: Size.zero,
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 8,
//                           vertical: 4,
//                         ),
//                         tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                       ),
//                       onPressed: onClearRecent,
//                       child: const Text('مسح'),
//                     ),
//                 ],
//               ),
//               const SizedBox(height: 6),
//               SizedBox(
//                 height: 42,
//                 child: ListView.separated(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: visibleChips.length,
//                   separatorBuilder: (_, __) => const SizedBox(width: 8),
//                   itemBuilder: (context, index) {
//                     final item = visibleChips[index];

//                     return ActionChip(
//                       visualDensity: VisualDensity.compact,
//                       avatar: Icon(
//                         suggestions.isNotEmpty
//                             ? Icons.bolt_rounded
//                             : Icons.history_rounded,
//                         size: 17,
//                       ),
//                       label: ConstrainedBox(
//                         constraints: BoxConstraints(
//                           maxWidth: MediaQuery.of(context).size.width * .48,
//                         ),
//                         child: Text(
//                           item,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       onPressed: () {
//                         if (suggestions.isNotEmpty) {
//                           onSuggestionTap(item);
//                         } else {
//                           onRecentTap(item);
//                         }
//                       },
//                     );
//                   },
//                 ),
//               ),
//               const SizedBox(height: 10),
//             ] else
//               const SizedBox(height: 12),
//             Row(
//               children: [
//                 const Icon(
//                   Icons.format_list_numbered_rtl_rounded,
//                   size: 18,
//                   color: AppColors.green,
//                 ),
//                 const SizedBox(width: 6),
//                 Text(
//                   '$resultCount نتيجة',
//                   style: const TextStyle(fontWeight: FontWeight.w900),
//                 ),
//                 const Spacer(),
//                 if (MediaQuery.of(context).size.width >= 370)
//                   const Text(
//                     'اضغط على أي نتيجة للتفاصيل',
//                     style: TextStyle(color: AppColors.greyText, fontSize: 12),
//                   ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _ResultCard extends StatelessWidget {
//   const _ResultCard({
//     required this.entry,
//     required this.isFavorite,
//     required this.onTap,
//     required this.onFavoriteTap,
//   });

//   final CiscoEntry entry;
//   final bool isFavorite;
//   final VoidCallback onTap;
//   final VoidCallback onFavoriteTap;

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return InkWell(
//       borderRadius: BorderRadius.circular(22),
//       onTap: onTap,
//       child: Ink(
//         decoration: BoxDecoration(
//           color: isDark ? const Color(0xFF10241C) : Colors.white,
//           borderRadius: BorderRadius.circular(22),
//           border: Border.all(
//             color: isDark ? Colors.white.withOpacity(.08) : AppColors.border,
//           ),
//           boxShadow: const [
//             BoxShadow(
//               color: Color(0x12006B48),
//               blurRadius: 18,
//               offset: Offset(0, 8),
//             ),
//           ],
//         ),
//         padding: const EdgeInsets.all(14),
//         child: Row(
//           children: [
//             Container(
//               width: 58,
//               height: 58,
//               decoration: BoxDecoration(
//                 color: isDark
//                     ? Colors.white.withOpacity(.08)
//                     : const Color(0xFFE8F8F0),
//                 borderRadius: BorderRadius.circular(18),
//               ),
//               child: const Icon(
//                 Icons.local_post_office_rounded,
//                 color: AppColors.green,
//                 size: 30,
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     entry.name,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w900,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     entry.region,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       color: AppColors.greyText,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   if (entry.description.trim().isNotEmpty) ...[
//                     const SizedBox(height: 4),
//                     Text(
//                       entry.description,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(color: Color(0xFF8A9A93)),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//             const SizedBox(width: 8),
//             Column(
//               children: [
//                 IconButton(
//                   tooltip: isFavorite ? 'إزالة من المفضلة' : 'إضافة للمفضلة',
//                   onPressed: onFavoriteTap,
//                   icon: Icon(
//                     isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
//                     color: isFavorite ? Colors.amber : AppColors.greyText,
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 10,
//                     vertical: 7,
//                   ),
//                   decoration: BoxDecoration(
//                     color: AppColors.darkGreen,
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                   child: Text(
//                     entry.cisco,
//                     textDirection: TextDirection.ltr,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w900,
//                       letterSpacing: .5,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// void showCiscoDetails({
//   required BuildContext context,
//   required CiscoEntry entry,
//   required bool isFavorite,
//   required VoidCallback onToggleFavorite,
// }) {
//   showModalBottomSheet<void>(
//     context: context,
//     showDragHandle: true,
//     isScrollControlled: true,
//     backgroundColor: Theme.of(context).colorScheme.surface,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
//     ),
//     builder: (context) {
//       return Directionality(
//         textDirection: TextDirection.rtl,
//         child: Padding(
//           padding: EdgeInsets.only(
//             left: 22,
//             right: 22,
//             top: 4,
//             bottom: MediaQuery.of(context).padding.bottom + 22,
//           ),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Row(
//                   children: [
//                     const _LogoMark(size: 54),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             entry.name,
//                             style: const TextStyle(
//                               fontSize: 22,
//                               fontWeight: FontWeight.w900,
//                             ),
//                           ),
//                           Text(
//                             entry.region,
//                             style: const TextStyle(
//                               color: AppColors.greyText,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     IconButton.filledTonal(
//                       onPressed: onToggleFavorite,
//                       icon: Icon(
//                         isFavorite
//                             ? Icons.star_rounded
//                             : Icons.star_border_rounded,
//                         color: isFavorite ? Colors.amber : null,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 18),
//                 _InfoTile(
//                   label: 'رقم السيسكو',
//                   value: entry.cisco,
//                   isNumber: true,
//                 ),
//                 _InfoTile(
//                   label: 'الوصف / الوظيفة',
//                   value: entry.description,
//                 ),
//                 if (entry.notes.trim().isNotEmpty)
//                   _InfoTile(label: 'ملاحظات', value: entry.notes),
//                 const SizedBox(height: 12),
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).brightness == Brightness.dark
//                         ? Colors.white.withOpacity(.04)
//                         : const Color(0xFFF4FBF7),
//                     borderRadius: BorderRadius.circular(22),
//                     border: Border.all(
//                       color: Theme.of(context).brightness == Brightness.dark
//                           ? Colors.white.withOpacity(.08)
//                           : AppColors.border,
//                     ),
//                   ),
//                   child: Column(
//                     children: [
//                       const Text(
//                         'QR Code لرقم السيسكو',
//                         style: TextStyle(fontWeight: FontWeight.w900),
//                       ),
//                       const SizedBox(height: 12),
//                       Container(
//                         color: Colors.white,
//                         padding: const EdgeInsets.all(12),
//                         child: QrImageView(
//                           data: entry.cisco,
//                           version: QrVersions.auto,
//                           size: 150,
//                           backgroundColor: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: FilledButton.icon(
//                         onPressed: () {
//                           Clipboard.setData(ClipboardData(text: entry.cisco));
//                           Navigator.pop(context);
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text(
//                                 'تم نسخ رقم السيسكو: ${entry.cisco}',
//                               ),
//                               behavior: SnackBarBehavior.floating,
//                             ),
//                           );
//                         },
//                         icon: const Icon(Icons.copy_rounded),
//                         label: const Text('نسخ'),
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: FilledButton.tonalIcon(
//                         onPressed: () => Share.share(entry.shareText),
//                         icon: const Icon(Icons.share_rounded),
//                         label: const Text('مشاركة'),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }

// class CardsHubScreen extends StatelessWidget {
//   const CardsHubScreen({
//     super.key,
//     required this.all,
//     required this.regions,
//     required this.favoritesCount,
//     required this.recentSearches,
//     required this.onOpenSearch,
//   });

//   final List<CiscoEntry> all;
//   final List<String> regions;
//   final int favoritesCount;
//   final List<String> recentSearches;
//   final void Function({
//     String? query,
//     String? type,
//     String? region,
//   }) onOpenSearch;

//   int _countType(String type) {
//     if (type == 'مكاتب البريد') {
//       return all.where((e) => e.description.contains('مكتب بريد')).length;
//     }
//     if (type == 'مناطق التوزيع') {
//       return all
//           .where(
//             (e) =>
//                 e.region.contains('مناطق التوزيع') ||
//                 e.description.contains('توزيع'),
//           )
//           .length;
//     }
//     if (type == 'القطاعات') {
//       return all.where((e) => e.region.contains('القطاعات')).length;
//     }
//     return all.length;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final cards = [
//       _HubCardData(
//         title: 'كل الأرقام',
//         subtitle: '${all.length} رقم متاح',
//         icon: Icons.dialpad_rounded,
//         color: AppColors.green,
//         onTap: () => onOpenSearch(type: 'الكل'),
//       ),
//       _HubCardData(
//         title: 'مكاتب البريد',
//         subtitle: '${_countType('مكاتب البريد')} نتيجة',
//         icon: Icons.local_post_office_rounded,
//         color: const Color(0xFF0E8FD8),
//         onTap: () => onOpenSearch(type: 'مكاتب البريد'),
//       ),
//       _HubCardData(
//         title: 'مناطق التوزيع',
//         subtitle: '${_countType('مناطق التوزيع')} نتيجة',
//         icon: Icons.local_shipping_rounded,
//         color: const Color(0xFFE09022),
//         onTap: () => onOpenSearch(type: 'مناطق التوزيع'),
//       ),
//       _HubCardData(
//         title: 'القطاعات',
//         subtitle: '${_countType('القطاعات')} نتيجة',
//         icon: Icons.account_tree_rounded,
//         color: const Color(0xFF7B61FF),
//         onTap: () => onOpenSearch(type: 'القطاعات'),
//       ),
//       _HubCardData(
//         title: 'المفضلة',
//         subtitle: '$favoritesCount رقم محفوظ',
//         icon: Icons.star_rounded,
//         color: Colors.amber,
//         onTap: () => onOpenSearch(query: ''),
//       ),
//       _HubCardData(
//         title: 'آخر بحث',
//         subtitle:
//             recentSearches.isEmpty ? 'لا يوجد بحث بعد' : recentSearches.first,
//         icon: Icons.history_rounded,
//         color: const Color(0xFF546E7A),
//         onTap: () {
//           if (recentSearches.isNotEmpty) {
//             onOpenSearch(query: recentSearches.first);
//           } else {
//             onOpenSearch();
//           }
//         },
//       ),
//     ];

//     return Scaffold(
//       appBar: AppBar(title: const Text('الأقسام السريعة')),
//       body: CustomScrollView(
//         slivers: [
//           SliverToBoxAdapter(
//             child: Container(
//               margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   begin: Alignment.topRight,
//                   end: Alignment.bottomLeft,
//                   colors: [AppColors.green, AppColors.darkGreen],
//                 ),
//                 borderRadius: BorderRadius.circular(28),
//               ),
//               child: Row(
//                 children: [
//                   const _LogoMark(size: 68),
//                   const SizedBox(width: 14),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           'من تبحث عنه اليوم؟',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 22,
//                             fontWeight: FontWeight.w900,
//                           ),
//                         ),
//                         const SizedBox(height: 6),
//                         Text(
//                           'اختار القسم وابدأ أسرع بدل الدوران في القوائم كأنها متاهة حكومية.',
//                           style: TextStyle(
//                             color: Colors.white.withOpacity(.82),
//                             height: 1.4,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           SliverLayoutBuilder(
//             builder: (context, constraints) {
//               final width = constraints.crossAxisExtent;
//               final columns = width < 360 ? 1 : 2;
//               final cardHeight = width < 360 ? 132.0 : 155.0;

//               return SliverPadding(
//                 padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
//                 sliver: SliverGrid.builder(
//                   itemCount: cards.length,
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: columns,
//                     mainAxisExtent: cardHeight,
//                     mainAxisSpacing: 12,
//                     crossAxisSpacing: 12,
//                   ),
//                   itemBuilder: (context, index) {
//                     final card = cards[index];

//                     return _HubCard(data: card);
//                   },
//                 ),
//               );
//             },
//           ),
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
//               child: FilledButton.icon(
//                 onPressed: () => onOpenSearch(),
//                 icon: const Icon(Icons.search_rounded),
//                 label: const Text('فتح البحث السريع'),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _HubCardData {
//   _HubCardData({
//     required this.title,
//     required this.subtitle,
//     required this.icon,
//     required this.color,
//     required this.onTap,
//   });

//   final String title;
//   final String subtitle;
//   final IconData icon;
//   final Color color;
//   final VoidCallback onTap;
// }

// class _HubCard extends StatelessWidget {
//   const _HubCard({required this.data});

//   final _HubCardData data;

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return InkWell(
//       borderRadius: BorderRadius.circular(26),
//       onTap: data.onTap,
//       child: Ink(
//         decoration: BoxDecoration(
//           color: isDark ? const Color(0xFF10241C) : Colors.white,
//           borderRadius: BorderRadius.circular(26),
//           border: Border.all(
//             color: isDark ? Colors.white.withOpacity(.08) : AppColors.border,
//           ),
//           boxShadow: const [
//             BoxShadow(
//               color: Color(0x10006B48),
//               blurRadius: 18,
//               offset: Offset(0, 9),
//             ),
//           ],
//         ),
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               width: 48,
//               height: 48,
//               decoration: BoxDecoration(
//                 color: data.color.withOpacity(.13),
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Icon(data.icon, color: data.color, size: 28),
//             ),
//             const Spacer(),
//             Text(
//               data.title,
//               style: const TextStyle(
//                 fontSize: 17,
//                 fontWeight: FontWeight.w900,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               data.subtitle,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(color: AppColors.greyText),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class FavoritesScreen extends StatelessWidget {
//   const FavoritesScreen({
//     super.key,
//     required this.all,
//     required this.favorites,
//     required this.onToggleFavorite,
//     required this.onOpenDetails,
//   });

//   final List<CiscoEntry> all;
//   final Set<int> favorites;
//   final Future<void> Function(CiscoEntry entry) onToggleFavorite;
//   final void Function(CiscoEntry entry) onOpenDetails;

//   @override
//   Widget build(BuildContext context) {
//     final items = all.where((e) => favorites.contains(e.id)).toList();

//     return Scaffold(
//       appBar: AppBar(title: const Text('المفضلة')),
//       body: items.isEmpty
//           ? const _FavoritesEmpty()
//           : ListView.separated(
//               padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
//               itemCount: items.length,
//               separatorBuilder: (_, __) => const SizedBox(height: 10),
//               itemBuilder: (context, index) {
//                 final item = items[index];

//                 return _ResultCard(
//                   entry: item,
//                   isFavorite: true,
//                   onTap: () => onOpenDetails(item),
//                   onFavoriteTap: () => onToggleFavorite(item),
//                 );
//               },
//             ),
//     );
//   }
// }

// class _FavoritesEmpty extends StatelessWidget {
//   const _FavoritesEmpty();

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Padding(
//         padding: EdgeInsets.all(28),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(Icons.star_border_rounded, size: 72, color: AppColors.green),
//             SizedBox(height: 14),
//             Text(
//               'لا توجد أرقام في المفضلة',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
//             ),
//             SizedBox(height: 8),
//             Text(
//               'اضغط على علامة النجمة بجانب أي نتيجة لحفظها هنا.',
//               textAlign: TextAlign.center,
//               style: TextStyle(color: AppColors.greyText),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class SettingsScreen extends StatelessWidget {
//   const SettingsScreen({
//     super.key,
//     required this.total,
//     required this.favoritesCount,
//     required this.recentCount,
//     required this.recentSearches,
//     required this.onClearRecent,
//   });

//   final int total;
//   final int favoritesCount;
//   final int recentCount;
//   final List<String> recentSearches;
//   final VoidCallback onClearRecent;

//   void _showRecentSearches(BuildContext context) {
//     showModalBottomSheet<void>(
//       context: context,
//       showDragHandle: true,
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
//       ),
//       builder: (context) {
//         return Directionality(
//           textDirection: TextDirection.rtl,
//           child: Padding(
//             padding: EdgeInsets.only(
//               left: 20,
//               right: 20,
//               top: 8,
//               bottom: MediaQuery.of(context).padding.bottom + 22,
//             ),
//             child: recentSearches.isEmpty
//                 ? const Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(
//                         Icons.history_rounded,
//                         color: AppColors.green,
//                         size: 54,
//                       ),
//                       SizedBox(height: 12),
//                       Text(
//                         'لا توجد عمليات بحث بعد',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.w900,
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       Text(
//                         'أي كلمة تبحث عنها ستظهر هنا بعد الضغط على زر البحث من لوحة المفاتيح.',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(color: AppColors.greyText),
//                       ),
//                     ],
//                   )
//                 : Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       const Text(
//                         'آخر عمليات البحث',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.w900,
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       Flexible(
//                         child: ListView.separated(
//                           shrinkWrap: true,
//                           itemCount: recentSearches.length,
//                           separatorBuilder: (_, __) => const Divider(height: 1),
//                           itemBuilder: (context, index) {
//                             final item = recentSearches[index];

//                             return ListTile(
//                               leading: const Icon(
//                                 Icons.history_rounded,
//                                 color: AppColors.green,
//                               ),
//                               title: Text(
//                                 item,
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       FilledButton.tonalIcon(
//                         onPressed: () {
//                           Navigator.pop(context);
//                           onClearRecent();
//                         },
//                         icon: const Icon(Icons.delete_sweep_rounded),
//                         label: const Text('مسح آخر عمليات البحث'),
//                       ),
//                     ],
//                   ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final settings = AppSettingsScope.of(context);

//     return Scaffold(
//       appBar: AppBar(title: const Text('الإعدادات')),
//       body: ListView(
//         padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
//         children: [
//           Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 begin: Alignment.topRight,
//                 end: Alignment.bottomLeft,
//                 colors: [AppColors.green, AppColors.darkGreen],
//               ),
//               borderRadius: BorderRadius.circular(28),
//             ),
//             child: const Column(
//               children: [
//                 _LogoMark(size: 86),
//                 SizedBox(height: 16),
//                 Text(
//                   'Egypt Post Cisco',
//                   textDirection: TextDirection.ltr,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 24,
//                     fontWeight: FontWeight.w900,
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   'تطبيق داخلي لتسهيل الوصول إلى أرقام السيسكو الخاصة بجهات البريد المصري.',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(color: Colors.white, height: 1.5),
//                 ),
//                 SizedBox(height: 12),
//                 Text(
//                   'اهداء من إدارة التكنولوجيا والمعلومات بمنطقة برج العرب إلى جميع موظفي البريد المصري.\n\nتنفيذ : م/ احمد نابغ موسي',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Colors.white,
//                     height: 1.5,
//                     fontWeight: FontWeight.w800,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),
//           SwitchListTile(
//             value: settings.isDarkMode,
//             onChanged: settings.onThemeChanged,
//             secondary: const Icon(Icons.dark_mode_rounded),
//             title: const Text(
//               'الوضع الليلي',
//               style: TextStyle(fontWeight: FontWeight.w900),
//             ),
//             subtitle: const Text('تغيير شكل التطبيق للعرض الليلي.'),
//           ),
//           const Divider(),
//           _SettingsTile(
//             icon: Icons.dialpad_rounded,
//             title: 'إجمالي الأرقام',
//             value: '$total',
//           ),
//           _SettingsTile(
//             icon: Icons.star_rounded,
//             title: 'الأرقام المفضلة',
//             value: '$favoritesCount',
//           ),
//           _SettingsTile(
//             icon: Icons.history_rounded,
//             title: 'آخر عمليات البحث',
//             value: '$recentCount',
//             onTap: () => _showRecentSearches(context),
//           ),
//           const SizedBox(height: 8),
//           FilledButton.tonalIcon(
//             onPressed: onClearRecent,
//             icon: const Icon(Icons.delete_sweep_rounded),
//             label: const Text('مسح آخر عمليات البحث'),
//           ),
//           const SizedBox(height: 14),
//           const Text(
//             'تنبيه: البيانات للاستخدام الداخلي، وتعتمد دقتها على آخر ملف تم إضافته داخل التطبيق.',
//             textAlign: TextAlign.center,
//             style: TextStyle(color: AppColors.greyText, height: 1.5),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _SettingsTile extends StatelessWidget {
//   const _SettingsTile({
//     required this.icon,
//     required this.title,
//     required this.value,
//     this.onTap,
//   });

//   final IconData icon;
//   final String title;
//   final String value;
//   final VoidCallback? onTap;

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       onTap: onTap,
//       leading: Icon(icon, color: AppColors.green),
//       title: Text(
//         title,
//         style: const TextStyle(fontWeight: FontWeight.w800),
//       ),
//       trailing: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             value,
//             style: const TextStyle(
//               fontWeight: FontWeight.w900,
//               fontSize: 16,
//             ),
//           ),
//           if (onTap != null) ...[
//             const SizedBox(width: 8),
//             const Icon(Icons.chevron_left_rounded),
//           ],
//         ],
//       ),
//     );
//   }
// }

// class _InfoTile extends StatelessWidget {
//   const _InfoTile({
//     required this.label,
//     required this.value,
//     this.isNumber = false,
//   });

//   final String label;
//   final String value;
//   final bool isNumber;

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: isDark ? Colors.white.withOpacity(.04) : AppColors.paleGreen,
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(
//           color: isDark ? Colors.white.withOpacity(.08) : AppColors.border,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: const TextStyle(
//               color: AppColors.greyText,
//               fontWeight: FontWeight.bold,
//               fontSize: 12,
//             ),
//           ),
//           const SizedBox(height: 5),
//           Text(
//             value.isEmpty ? '-' : value,
//             textDirection: isNumber ? TextDirection.ltr : TextDirection.rtl,
//             style: TextStyle(
//               fontSize: isNumber ? 26 : 16,
//               fontWeight: FontWeight.w900,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _LogoMark extends StatelessWidget {
//   const _LogoMark({required this.size});

//   final double size;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: size,
//       height: size,
//       padding: const EdgeInsets.all(5),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         shape: BoxShape.circle,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(.12),
//             blurRadius: 14,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: ClipOval(
//         child: Image.asset(
//           'assets/images/egypt_post_logo.png',
//           fit: BoxFit.cover,
//         ),
//       ),
//     );
//   }
// }

// class _StatPill extends StatelessWidget {
//   const _StatPill({
//     required this.icon,
//     required this.label,
//     required this.value,
//   });

//   final IconData icon;
//   final String label;
//   final String value;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 12,
//         vertical: 10,
//       ),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(.16),
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(color: Colors.white.withOpacity(.22)),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, color: Colors.white, size: 20),
//           const SizedBox(width: 8),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 value,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w900,
//                   fontSize: 15,
//                 ),
//               ),
//               Text(
//                 label,
//                 style: TextStyle(
//                   color: Colors.white.withOpacity(.82),
//                   fontSize: 11,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _EmptyState extends StatelessWidget {
//   const _EmptyState({required this.onReset});

//   final VoidCallback onReset;

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(28),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Image.asset(
//               'assets/images/egypt_post_logo.png',
//               width: 92,
//               height: 92,
//             ),
//             const SizedBox(height: 18),
//             const Text(
//               'لا توجد نتائج مطابقة',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w900,
//               ),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'جرّب البحث بجزء من الاسم، أو رقم السيسكو مباشرة، أو اختر كل المناطق.',
//               textAlign: TextAlign.center,
//               style: TextStyle(color: AppColors.greyText),
//             ),
//             const SizedBox(height: 14),
//             FilledButton.tonalIcon(
//               onPressed: onReset,
//               icon: const Icon(Icons.refresh_rounded),
//               label: const Text('إعادة ضبط البحث'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _OnboardingItem extends StatelessWidget {
//   const _OnboardingItem({
//     required this.icon,
//     required this.title,
//     required this.text,
//   });

//   final IconData icon;
//   final String title;
//   final String text;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Icon(icon, color: AppColors.green),
//         const SizedBox(width: 10),
//         Expanded(
//           child: RichText(
//             text: TextSpan(
//               style: DefaultTextStyle.of(context).style,
//               children: [
//                 TextSpan(
//                   text: '$title\n',
//                   style: const TextStyle(fontWeight: FontWeight.w900),
//                 ),
//                 TextSpan(
//                   text: text,
//                   style: const TextStyle(
//                     color: AppColors.greyText,
//                     height: 1.4,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _SearchHeaderDelegate extends SliverPersistentHeaderDelegate {
//   _SearchHeaderDelegate({
//     required this.child,
//     required this.minHeight,
//     required this.maxHeight,
//   });

//   final Widget child;
//   final double minHeight;
//   final double maxHeight;

//   @override
//   double get minExtent => minHeight;

//   @override
//   double get maxExtent => maxHeight;

//   @override
//   Widget build(
//     BuildContext context,
//     double shrinkOffset,
//     bool overlapsContent,
//   ) {
//     return child;
//   }

//   @override
//   bool shouldRebuild(covariant _SearchHeaderDelegate oldDelegate) {
//     return oldDelegate.child != child ||
//         oldDelegate.minHeight != minHeight ||
//         oldDelegate.maxHeight != maxHeight;
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const EgyptPostCiscoApp());
}

class EgyptPostCiscoApp extends StatefulWidget {
  const EgyptPostCiscoApp({super.key});

  @override
  State<EgyptPostCiscoApp> createState() => _EgyptPostCiscoAppState();
}

class _EgyptPostCiscoAppState extends State<EgyptPostCiscoApp> {
  ThemeMode _themeMode = ThemeMode.light;

  static const Color seed = Color(0xFF07965F);

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(AppPrefs.darkModeKey) ?? false;
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  Future<void> _toggleTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppPrefs.darkModeKey, value);
    setState(() {
      _themeMode = value ? ThemeMode.dark : ThemeMode.light;
    });
  }

  ThemeData _lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seed,
        primary: seed,
        secondary: const Color(0xFF013F2B),
        surface: const Color(0xFFF4FBF7),
      ),
      scaffoldBackgroundColor: const Color(0xFFF4FBF7),
      fontFamily: 'Arial',
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Color(0xFF003D2A),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  ThemeData _darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: seed,
        primary: seed,
        secondary: const Color(0xFF22C483),
        surface: const Color(0xFF10241C),
      ),
      scaffoldBackgroundColor: const Color(0xFF071A13),
      fontFamily: 'Arial',
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF10241C),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppSettingsScope(
      isDarkMode: _themeMode == ThemeMode.dark,
      onThemeChanged: _toggleTheme,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Egypt Post Cisco',
        theme: _lightTheme(),
        darkTheme: _darkTheme(),
        themeMode: _themeMode,
        home: const Directionality(
          textDirection: TextDirection.rtl,
          child: SplashScreen(),
        ),
      ),
    );
  }
}

class AppPrefs {
  static const String favoritesKey = 'favorite_cisco_ids';
  static const String recentSearchesKey = 'recent_searches';
  static const String onboardingDoneKey = 'onboarding_done';
  static const String darkModeKey = 'dark_mode_enabled';
}

class AppSettingsScope extends InheritedWidget {
  const AppSettingsScope({
    super.key,
    required super.child,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  static AppSettingsScope of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<AppSettingsScope>();
    assert(scope != null, 'AppSettingsScope not found');
    return scope!;
  }

  @override
  bool updateShouldNotify(AppSettingsScope oldWidget) {
    return oldWidget.isDarkMode != isDarkMode;
  }
}

class AppColors {
  static const green = Color(0xFF07965F);
  static const darkGreen = Color(0xFF003D2A);
  static const midGreen = Color(0xFF006B48);
  static const paleGreen = Color(0xFFF4FBF7);
  static const border = Color(0xFFE2F1EA);
  static const greyText = Color(0xFF70877E);
}

class CiscoEntry {
  CiscoEntry({
    required this.id,
    required this.region,
    required this.name,
    required this.description,
    required this.cisco,
    required this.notes,
  });

  final int id;
  final String region;
  final String name;
  final String description;
  final String cisco;
  final String notes;

  factory CiscoEntry.fromJson(Map<String, dynamic> json) {
    return CiscoEntry(
      id: json['id'] as int,
      region: json['region'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      cisco: json['cisco'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
    );
  }

  String get shareText {
    return '''
Egypt Post Cisco

الاسم: $name
المنطقة: $region
الوصف: ${description.isEmpty ? '-' : description}
رقم السيسكو: $cisco
''';
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _scaleAnimation = Tween<double>(begin: .82, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, .18),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 850),
          pageBuilder: (_, animation, __) {
            return FadeTransition(
              opacity: animation,
              child: const Directionality(
                textDirection: TextDirection.rtl,
                child: MainShell(),
              ),
            );
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _backgroundLogo({
    required double size,
    required double opacity,
  }) {
    return Opacity(
      opacity: opacity,
      child: Image.asset(
        'assets/images/egypt_post_logo.png',
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                AppColors.green,
                AppColors.midGreen,
                AppColors.darkGreen,
              ],
            ),
          ),
          child: Stack(
            children: [
              PositionedDirectional(
                top: -95,
                end: -75,
                child: _backgroundLogo(size: 285, opacity: .09),
              ),
              PositionedDirectional(
                bottom: -110,
                start: -90,
                child: _backgroundLogo(size: 320, opacity: .075),
              ),
              PositionedDirectional(
                top: MediaQuery.of(context).padding.top + 34,
                start: 26,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.13),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: Colors.white.withOpacity(.22)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.security_rounded,
                          color: Colors.white, size: 18),
                      SizedBox(width: 7),
                      Text(
                        'منطقة برج العرب',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 26),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 144,
                              height: 144,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(.25),
                                    blurRadius: 32,
                                    offset: const Offset(0, 16),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/egypt_post_logo.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 28),
                            const Text(
                              'Egypt Post Cisco',
                              textDirection: TextDirection.ltr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 31,
                                fontWeight: FontWeight.w900,
                                letterSpacing: .4,
                              ),
                            ),
                            const SizedBox(height: 9),
                            Text(
                              'دليل أرقام السيسكو للبريد المصري',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withOpacity(.88),
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 34),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 23,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.14),
                                borderRadius: BorderRadius.circular(28),
                                border: Border.all(
                                  color: Colors.white.withOpacity(.24),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(.10),
                                    blurRadius: 24,
                                    offset: const Offset(0, 12),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 5,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(.55),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  const Text(
                                    'اهداء من إدارة التكنولوجيا والمعلومات\nبمنطقة برج العرب\nإلى جميع موظفي البريد المصري\n\nتنفيذ : م/ احمد نابغ موسي',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      height: 1.55,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 34),
                            SizedBox(
                              width: 36,
                              height: 36,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                                backgroundColor: Colors.white.withOpacity(.22),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              PositionedDirectional(
                bottom: MediaQuery.of(context).padding.bottom + 28,
                start: 24,
                end: 24,
                child: Text(
                  'Powered by Egypt Post Technology & Information',
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(.62),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: .2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  List<CiscoEntry> _all = const [];
  List<String> _regions = const [];
  Set<int> _favorites = {};
  List<String> _recentSearches = [];
  bool _loading = true;

  final GlobalKey<CiscoHomePageState> _homeKey =
      GlobalKey<CiscoHomePageState>();

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await Future.wait([
      _loadData(),
      _loadFavorites(),
      _loadRecentSearches(),
    ]);

    if (!mounted) return;

    setState(() => _loading = false);
    await _showOnboardingIfNeeded();
  }

  Future<void> _loadData() async {
    final raw = await rootBundle.loadString('assets/data/cisco_directory.json');
    final decoded = jsonDecode(raw) as List<dynamic>;
    final loaded = decoded
        .map((e) => CiscoEntry.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);

    final regions = loaded.map((e) => e.region).toSet().toList()..sort();

    _all = loaded;
    _regions = ['كل المناطق', ...regions];
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(AppPrefs.favoritesKey) ?? [];
    _favorites = raw.map(int.parse).toSet();
  }

  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    _recentSearches = prefs.getStringList(AppPrefs.recentSearchesKey) ?? [];
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      AppPrefs.favoritesKey,
      _favorites.map((e) => e.toString()).toList(),
    );
  }

  Future<void> _saveRecentSearch(String value) async {
    final query = value.trim();
    if (query.isEmpty) return;

    _recentSearches.removeWhere((e) => e == query);
    _recentSearches.insert(0, query);

    if (_recentSearches.length > 10) {
      _recentSearches = _recentSearches.take(10).toList();
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(AppPrefs.recentSearchesKey, _recentSearches);

    if (mounted) setState(() {});
  }

  Future<void> _clearRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppPrefs.recentSearchesKey);
    setState(() => _recentSearches = []);
  }

  Future<void> _showOnboardingIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final done = prefs.getBool(AppPrefs.onboardingDoneKey) ?? false;

    if (done || !mounted) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          title: const Text(
            'مرحبًا بك في Egypt Post Cisco',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _OnboardingItem(
                icon: Icons.search_rounded,
                title: 'بحث سريع',
                text: 'ابحث بالاسم، المكان، الوظيفة أو رقم السيسكو.',
              ),
              SizedBox(height: 12),
              _OnboardingItem(
                icon: Icons.star_rounded,
                title: 'المفضلة',
                text: 'احفظ الأرقام المهمة للوصول لها بسرعة.',
              ),
              SizedBox(height: 12),
              _OnboardingItem(
                icon: Icons.share_rounded,
                title: 'مشاركة و QR',
                text: 'شارك بيانات الجهة أو اعرض الرقم كـ QR Code.',
              ),
            ],
          ),
          actions: [
            FilledButton(
              onPressed: () async {
                await prefs.setBool(AppPrefs.onboardingDoneKey, true);
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('ابدأ الآن'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleFavorite(CiscoEntry entry) async {
    setState(() {
      if (_favorites.contains(entry.id)) {
        _favorites.remove(entry.id);
      } else {
        _favorites.add(entry.id);
      }
    });

    await _saveFavorites();
  }

  void _openSearchWith({
    String? query,
    String? type,
    String? region,
  }) {
    setState(() => _index = 0);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _homeKey.currentState?.setSearchAndFilters(
        query: query,
        type: type,
        region: region,
      );
    });
  }

  void _openDetails(CiscoEntry entry) {
    showCiscoDetails(
      context: context,
      entry: entry,
      isFavorite: _favorites.contains(entry.id),
      onToggleFavorite: () => _toggleFavorite(entry),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final pages = [
      CiscoHomePage(
        key: _homeKey,
        all: _all,
        regions: _regions,
        favorites: _favorites,
        recentSearches: _recentSearches,
        onSaveRecentSearch: _saveRecentSearch,
        onClearRecentSearches: _clearRecentSearches,
        onToggleFavorite: _toggleFavorite,
        onOpenDetails: _openDetails,
      ),
      CardsHubScreen(
        all: _all,
        regions: _regions,
        favoritesCount: _favorites.length,
        recentSearches: _recentSearches,
        onOpenSearch: _openSearchWith,
      ),
      FavoritesScreen(
        all: _all,
        favorites: _favorites,
        onToggleFavorite: _toggleFavorite,
        onOpenDetails: _openDetails,
      ),
      SettingsScreen(
        total: _all.length,
        favoritesCount: _favorites.length,
        recentCount: _recentSearches.length,
        recentSearches: _recentSearches,
        onClearRecent: _clearRecentSearches,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.search_rounded),
            selectedIcon: Icon(Icons.search_rounded),
            label: 'البحث',
          ),
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded),
            label: 'الأقسام',
          ),
          NavigationDestination(
            icon: Icon(Icons.star_border_rounded),
            selectedIcon: Icon(Icons.star_rounded),
            label: 'المفضلة',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: 'الإعدادات',
          ),
        ],
      ),
    );
  }
}

class CiscoHomePage extends StatefulWidget {
  const CiscoHomePage({
    super.key,
    required this.all,
    required this.regions,
    required this.favorites,
    required this.recentSearches,
    required this.onSaveRecentSearch,
    required this.onClearRecentSearches,
    required this.onToggleFavorite,
    required this.onOpenDetails,
  });

  final List<CiscoEntry> all;
  final List<String> regions;
  final Set<int> favorites;
  final List<String> recentSearches;
  final Future<void> Function(String value) onSaveRecentSearch;
  final Future<void> Function() onClearRecentSearches;
  final Future<void> Function(CiscoEntry entry) onToggleFavorite;
  final void Function(CiscoEntry entry) onOpenDetails;

  @override
  State<CiscoHomePage> createState() => CiscoHomePageState();
}

class CiscoHomePageState extends State<CiscoHomePage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  final stt.SpeechToText _speech = stt.SpeechToText();

  List<CiscoEntry> _filtered = const [];
  List<String> _suggestions = const [];

  String _query = '';
  String _selectedRegion = 'كل المناطق';
  String _selectedType = 'الكل';

  bool _voiceAvailable = false;
  bool _isListening = false;

  static const List<String> _types = [
    'الكل',
    'مكاتب البريد',
    'مناطق التوزيع',
    'القطاعات',
  ];

  @override
  void initState() {
    super.initState();

    _filtered = _rankedResults(widget.all, '');

    _searchController.addListener(() {
      _query = _searchController.text;
      _applyFilters();
      _buildSuggestions();
    });

    _initVoice();
  }

  Future<void> _initVoice() async {
    final available = await _speech.initialize();
    if (!mounted) return;
    setState(() => _voiceAvailable = available);
  }

  Future<void> _startVoiceSearch() async {
    if (!_voiceAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('البحث الصوتي غير متاح على هذا الجهاز.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
      return;
    }

    setState(() => _isListening = true);

    await _speech.listen(
      localeId: 'ar_EG',
      listenMode: stt.ListenMode.search,
      onResult: (result) {
        final recognized = result.recognizedWords.trim();
        if (recognized.isNotEmpty) {
          _searchController.text = recognized;
          _searchController.selection = TextSelection.collapsed(
            offset: recognized.length,
          );
        }

        if (result.finalResult) {
          setState(() => _isListening = false);
          widget.onSaveRecentSearch(recognized);
        }
      },
    );
  }

  void setSearchAndFilters({
    String? query,
    String? type,
    String? region,
  }) {
    if (query != null) {
      _searchController.text = query;
      _searchController.selection = TextSelection.collapsed(
        offset: query.length,
      );
    }

    setState(() {
      if (type != null) _selectedType = type;
      if (region != null) _selectedRegion = region;
    });

    _applyFilters();
  }

  String _normalize(String value) {
    return value
        .replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '')
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ى', 'ي')
        .replaceAll('ة', 'ه')
        .replaceAll('ؤ', 'و')
        .replaceAll('ئ', 'ي')
        .replaceAll('ٱ', 'ا')
        .replaceAll(RegExp(r'[^\u0600-\u06FFa-zA-Z0-9\s]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll('برج العرب', 'برجالعرب')
        .trim()
        .toLowerCase();
  }

  List<String> _tokens(String value) {
    return _normalize(value)
        .split(' ')
        .where((token) => token.trim().isNotEmpty)
        .toList(growable: false);
  }

  int _editDistance(String a, String b) {
    if (a == b) return 0;
    if (a.isEmpty) return b.length;
    if (b.isEmpty) return a.length;

    final previous = List<int>.generate(b.length + 1, (i) => i);
    final current = List<int>.filled(b.length + 1, 0);

    for (var i = 1; i <= a.length; i++) {
      current[0] = i;
      for (var j = 1; j <= b.length; j++) {
        final cost = a.codeUnitAt(i - 1) == b.codeUnitAt(j - 1) ? 0 : 1;
        current[j] = [
          current[j - 1] + 1,
          previous[j] + 1,
          previous[j - 1] + cost,
        ].reduce((x, y) => x < y ? x : y);
      }
      previous.setAll(0, current);
    }

    return previous[b.length];
  }

  bool _looseTokenMatch(String queryToken, String valueToken) {
    if (queryToken.isEmpty || valueToken.isEmpty) return false;
    if (valueToken.contains(queryToken)) return true;
    if (valueToken.startsWith(queryToken)) return true;

    final length = queryToken.length <= valueToken.length
        ? queryToken.length
        : valueToken.length;
    final prefix = valueToken.substring(0, length);

    if (queryToken.length <= 2) {
      return _editDistance(queryToken, prefix) <= 1;
    }

    return _editDistance(queryToken, prefix) <= 1;
  }

  bool _allQueryTokensMatch(String query, String value) {
    final queryTokens = _tokens(query);
    if (queryTokens.isEmpty) return true;

    final valueTokens = _tokens(value);
    if (valueTokens.isEmpty) return false;

    for (final queryToken in queryTokens) {
      final matched = valueTokens.any(
        (valueToken) => _looseTokenMatch(queryToken, valueToken),
      );
      if (!matched) return false;
    }

    return true;
  }

  bool _matchesType(CiscoEntry item) {
    switch (_selectedType) {
      case 'مكاتب البريد':
        return item.description.contains('مكتب بريد');
      case 'مناطق التوزيع':
        return item.region.contains('مناطق التوزيع') ||
            item.description.contains('توزيع');
      case 'القطاعات':
        return item.region.contains('القطاعات');
      default:
        return true;
    }
  }

  int _score(CiscoEntry item, String q) {
    if (q.isEmpty) return 1;

    final cisco = _normalize(item.cisco);
    final name = _normalize(item.name);
    final region = _normalize(item.region);
    final description = _normalize(item.description);
    final notes = _normalize(item.notes);
    final haystack = '$name $region $description $cisco $notes';
    final compactHaystack = haystack.replaceAll(' ', '');
    final compactQuery = q.replaceAll(' ', '');

    if (cisco == q) return 1000;
    if (cisco.startsWith(q)) return 930;
    if (name == q) return 900;
    if (name.startsWith(q)) return 850;
    if (name.contains(q)) return 800;
    if (compactQuery.isNotEmpty && compactHaystack.contains(compactQuery)) {
      return 760;
    }
    if (_allQueryTokensMatch(q, name)) return 720;
    if (region.startsWith(q)) return 650;
    if (region.contains(q)) return 600;
    if (_allQueryTokensMatch(q, region)) return 560;
    if (description.contains(q)) return 500;
    if (_allQueryTokensMatch(q, description)) return 460;
    if (notes.contains(q)) return 400;
    if (_allQueryTokensMatch(q, notes)) return 360;
    if (haystack.contains(q)) return 250;
    if (_allQueryTokensMatch(q, haystack)) return 180;

    return 0;
  }

  List<CiscoEntry> _rankedResults(List<CiscoEntry> source, String query) {
    final q = _normalize(query);

    final scored = source
        .map((entry) => MapEntry(entry, _score(entry, q)))
        .where((pair) => q.isEmpty || pair.value > 0)
        .toList();

    scored.sort((a, b) => b.value.compareTo(a.value));

    return scored.map((e) => e.key).toList(growable: false);
  }

  void _applyFilters() {
    final resultSource = widget.all.where((item) {
      final regionOk =
          _selectedRegion == 'كل المناطق' || item.region == _selectedRegion;
      final typeOk = _matchesType(item);
      return regionOk && typeOk;
    }).toList();

    final ranked = _rankedResults(resultSource, _query);

    setState(() => _filtered = ranked);
  }

  void _buildSuggestions() {
    final q = _normalize(_query);

    if (q.isEmpty) {
      setState(() => _suggestions = const []);
      return;
    }

    final names = <String>{};

    for (final item in widget.all) {
      final values = [
        item.name,
        item.region,
        item.description,
        item.cisco,
      ];

      for (final value in values) {
        if (value.trim().isEmpty) continue;
        final normalizedValue = _normalize(value);
        final compactValue = normalizedValue.replaceAll(' ', '');
        final compactQuery = q.replaceAll(' ', '');

        if (normalizedValue.contains(q) ||
            (compactQuery.isNotEmpty && compactValue.contains(compactQuery)) ||
            _allQueryTokensMatch(q, value)) {
          names.add(value.trim());
        }
      }

      if (names.length >= 8) break;
    }

    setState(() => _suggestions = names.take(8).toList());
  }

  Future<void> _onSearchSubmitted(String value) async {
    await widget.onSaveRecentSearch(value);
    _searchFocus.unfocus();
  }

  void _openAdvancedFilter() {
    String tempRegion = _selectedRegion;
    String tempType = _selectedType;

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: StatefulBuilder(
            builder: (context, setSheetState) {
              return Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 6,
                  bottom: MediaQuery.of(context).padding.bottom + 22,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'فلترة متقدمة',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: tempRegion,
                      isExpanded: true,
                      items: widget.regions
                          .map(
                            (region) => DropdownMenuItem(
                              value: region,
                              child: Text(
                                region,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setSheetState(() {
                          tempRegion = value ?? 'كل المناطق';
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'المنطقة',
                        prefixIcon: Icon(Icons.location_on_outlined),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: tempType,
                      isExpanded: true,
                      items: _types
                          .map(
                            (type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setSheetState(() {
                          tempType = value ?? 'الكل';
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'نوع الجهة',
                        prefixIcon: Icon(Icons.category_outlined),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () {
                              setState(() {
                                _selectedRegion = tempRegion;
                                _selectedType = tempType;
                              });
                              _applyFilters();
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.check_rounded),
                            label: const Text('تطبيق الفلتر'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton.filledTonal(
                          onPressed: () {
                            setSheetState(() {
                              tempRegion = 'كل المناطق';
                              tempType = 'الكل';
                            });
                          },
                          icon: const Icon(Icons.refresh_rounded),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _resetFilters() {
    _searchController.clear();
    setState(() {
      _selectedRegion = 'كل المناطق';
      _selectedType = 'الكل';
      _suggestions = const [];
    });
    _applyFilters();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _searchFocus.requestFocus(),
        icon: const Icon(Icons.search_rounded),
        label: const Text('بحث سريع'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _HeroHeader(total: widget.all.length)),
          SliverToBoxAdapter(
            child: SafeArea(
              top: false,
              bottom: false,
              child: _SearchPanel(
                controller: _searchController,
                focusNode: _searchFocus,
                selectedRegion: _selectedRegion,
                selectedType: _selectedType,
                resultCount: _filtered.length,
                suggestions: _suggestions,
                recentSearches: widget.recentSearches,
                isListening: _isListening,
                onVoiceTap: _startVoiceSearch,
                onSuggestionTap: (value) {
                  _searchController.text = value;
                  _searchController.selection = TextSelection.collapsed(
                    offset: value.length,
                  );
                  widget.onSaveRecentSearch(value);
                },
                onRecentTap: (value) {
                  _searchController.text = value;
                  _searchController.selection = TextSelection.collapsed(
                    offset: value.length,
                  );
                },
                onClearRecent: widget.onClearRecentSearches,
                onAdvancedFilter: _openAdvancedFilter,
                onReset: _resetFilters,
                onSubmitted: _onSearchSubmitted,
              ),
            ),
          ),
          if (_filtered.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _EmptyState(onReset: _resetFilters),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 90),
              sliver: SliverList.separated(
                itemCount: _filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final item = _filtered[index];

                  return _ResultCard(
                    entry: item,
                    isFavorite: widget.favorites.contains(item.id),
                    onTap: () => widget.onOpenDetails(item),
                    onFavoriteTap: () => widget.onToggleFavorite(item),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 22,
        left: 18,
        right: 18,
        bottom: 22,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [AppColors.green, AppColors.midGreen],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(34)),
      ),
      child: Stack(
        children: [
          PositionedDirectional(
            end: -45,
            bottom: -55,
            child: Opacity(
              opacity: .12,
              child: Image.asset(
                'assets/images/egypt_post_logo.png',
                width: 210,
                height: 210,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  _LogoMark(
                      size: MediaQuery.of(context).size.width < 370 ? 56 : 72),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Egypt Post Cisco',
                          textDirection: TextDirection.ltr,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width < 370
                                ? 20
                                : 24,
                            fontWeight: FontWeight.w900,
                            letterSpacing: .3,
                          ),
                        ),
                        Text(
                          'دليل أرقام السيسكو للبريد المصري',
                          style: TextStyle(
                            color: Colors.white.withOpacity(.86),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _StatPill(
                    icon: Icons.dialpad_rounded,
                    label: 'رقم محفوظ',
                    value: '$total+',
                  ),
                  const _StatPill(
                    icon: Icons.public_rounded,
                    label: 'بحث باسم أو مكان',
                    value: 'ذكي',
                  ),
                  const _StatPill(
                    icon: Icons.offline_bolt_rounded,
                    label: 'بدون إنترنت',
                    value: 'Offline',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SearchPanel extends StatelessWidget {
  const _SearchPanel({
    required this.controller,
    required this.focusNode,
    required this.selectedRegion,
    required this.selectedType,
    required this.resultCount,
    required this.suggestions,
    required this.recentSearches,
    required this.isListening,
    required this.onVoiceTap,
    required this.onSuggestionTap,
    required this.onRecentTap,
    required this.onClearRecent,
    required this.onAdvancedFilter,
    required this.onReset,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String selectedRegion;
  final String selectedType;
  final int resultCount;
  final List<String> suggestions;
  final List<String> recentSearches;
  final bool isListening;
  final VoidCallback onVoiceTap;
  final ValueChanged<String> onSuggestionTap;
  final ValueChanged<String> onRecentTap;
  final VoidCallback onClearRecent;
  final VoidCallback onAdvancedFilter;
  final VoidCallback onReset;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    final visibleChips = suggestions.isNotEmpty ? suggestions : recentSearches;
    final chipTitle = suggestions.isNotEmpty ? 'اقتراحات' : 'آخر بحث';

    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Column(
          children: [
            TextField(
              controller: controller,
              focusNode: focusNode,
              textInputAction: TextInputAction.search,
              onSubmitted: onSubmitted,
              decoration: InputDecoration(
                hintText:
                    'ابحث باسم المكتب، المكان، الوظيفة، أو رقم السيسكو...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: 'بحث بالصوت',
                      onPressed: onVoiceTap,
                      icon: Icon(
                        isListening
                            ? Icons.mic_rounded
                            : Icons.mic_none_rounded,
                        color: isListening ? Colors.red : null,
                      ),
                    ),
                    if (controller.text.isNotEmpty)
                      IconButton(
                        tooltip: 'مسح البحث',
                        onPressed: controller.clear,
                        icon: const Icon(Icons.close_rounded),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: onAdvancedFilter,
                    icon: const Icon(Icons.tune_rounded),
                    label: Text(
                      '$selectedRegion | $selectedType',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton.filledTonal(
                  tooltip: 'إعادة ضبط',
                  onPressed: onReset,
                  icon: const Icon(Icons.refresh_rounded),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (visibleChips.isNotEmpty) ...[
              Row(
                children: [
                  Text(
                    chipTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  if (suggestions.isEmpty && recentSearches.isNotEmpty)
                    TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: onClearRecent,
                      child: const Text('مسح'),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              SizedBox(
                height: 42,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: visibleChips.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final item = visibleChips[index];

                    return ActionChip(
                      visualDensity: VisualDensity.compact,
                      avatar: Icon(
                        suggestions.isNotEmpty
                            ? Icons.bolt_rounded
                            : Icons.history_rounded,
                        size: 17,
                      ),
                      label: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * .48,
                        ),
                        child: Text(
                          item,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      onPressed: () {
                        if (suggestions.isNotEmpty) {
                          onSuggestionTap(item);
                        } else {
                          onRecentTap(item);
                        }
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
            ] else
              const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.format_list_numbered_rtl_rounded,
                  size: 18,
                  color: AppColors.green,
                ),
                const SizedBox(width: 6),
                Text(
                  '$resultCount نتيجة',
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const Spacer(),
                if (MediaQuery.of(context).size.width >= 370)
                  const Text(
                    'اضغط على أي نتيجة للتفاصيل',
                    style: TextStyle(color: AppColors.greyText, fontSize: 12),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.entry,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteTap,
  });

  final CiscoEntry entry;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF10241C) : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isDark ? Colors.white.withOpacity(.08) : AppColors.border,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12006B48),
              blurRadius: 18,
              offset: Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(.08)
                    : const Color(0xFFE8F8F0),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.local_post_office_rounded,
                color: AppColors.green,
                size: 30,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    entry.region,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.greyText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (entry.description.trim().isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      entry.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Color(0xFF8A9A93)),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              children: [
                IconButton(
                  tooltip: isFavorite ? 'إزالة من المفضلة' : 'إضافة للمفضلة',
                  onPressed: onFavoriteTap,
                  icon: Icon(
                    isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                    color: isFavorite ? Colors.amber : AppColors.greyText,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.darkGreen,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    entry.cisco,
                    textDirection: TextDirection.ltr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      letterSpacing: .5,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void showCiscoDetails({
  required BuildContext context,
  required CiscoEntry entry,
  required bool isFavorite,
  required VoidCallback onToggleFavorite,
}) {
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (context) {
      var localFavorite = isFavorite;

      return StatefulBuilder(
        builder: (context, setSheetState) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: EdgeInsets.only(
                left: 22,
                right: 22,
                top: 4,
                bottom: MediaQuery.of(context).padding.bottom + 22,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const _LogoMark(size: 54),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.name,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                entry.region,
                                style: const TextStyle(
                                  color: AppColors.greyText,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton.filledTonal(
                          onPressed: () {
                            setSheetState(() {
                              localFavorite = !localFavorite;
                            });
                            onToggleFavorite();
                          },
                          icon: Icon(
                            localFavorite
                                ? Icons.star_rounded
                                : Icons.star_border_rounded,
                            color: localFavorite ? Colors.amber : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _InfoTile(
                      label: 'رقم السيسكو',
                      value: entry.cisco,
                      isNumber: true,
                    ),
                    _InfoTile(
                      label: 'الوصف / الوظيفة',
                      value: entry.description,
                    ),
                    if (entry.notes.trim().isNotEmpty)
                      _InfoTile(label: 'ملاحظات', value: entry.notes),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white.withOpacity(.04)
                            : const Color(0xFFF4FBF7),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white.withOpacity(.08)
                              : AppColors.border,
                        ),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'QR Code لرقم السيسكو',
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(12),
                            child: QrImageView(
                              data: entry.cisco,
                              version: QrVersions.auto,
                              size: 150,
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () {
                              Clipboard.setData(
                                  ClipboardData(text: entry.cisco));
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'تم نسخ رقم السيسكو: ${entry.cisco}',
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            icon: const Icon(Icons.copy_rounded),
                            label: const Text('نسخ'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FilledButton.tonalIcon(
                            onPressed: () => Share.share(entry.shareText),
                            icon: const Icon(Icons.share_rounded),
                            label: const Text('مشاركة'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

class CardsHubScreen extends StatelessWidget {
  const CardsHubScreen({
    super.key,
    required this.all,
    required this.regions,
    required this.favoritesCount,
    required this.recentSearches,
    required this.onOpenSearch,
  });

  final List<CiscoEntry> all;
  final List<String> regions;
  final int favoritesCount;
  final List<String> recentSearches;
  final void Function({
    String? query,
    String? type,
    String? region,
  }) onOpenSearch;

  int _countType(String type) {
    if (type == 'مكاتب البريد') {
      return all.where((e) => e.description.contains('مكتب بريد')).length;
    }
    if (type == 'مناطق التوزيع') {
      return all
          .where(
            (e) =>
                e.region.contains('مناطق التوزيع') ||
                e.description.contains('توزيع'),
          )
          .length;
    }
    if (type == 'القطاعات') {
      return all.where((e) => e.region.contains('القطاعات')).length;
    }
    return all.length;
  }

  @override
  Widget build(BuildContext context) {
    final cards = [
      _HubCardData(
        title: 'كل الأرقام',
        subtitle: '${all.length} رقم متاح',
        icon: Icons.dialpad_rounded,
        color: AppColors.green,
        onTap: () => onOpenSearch(type: 'الكل'),
      ),
      _HubCardData(
        title: 'مكاتب البريد',
        subtitle: '${_countType('مكاتب البريد')} نتيجة',
        icon: Icons.local_post_office_rounded,
        color: const Color(0xFF0E8FD8),
        onTap: () => onOpenSearch(type: 'مكاتب البريد'),
      ),
      _HubCardData(
        title: 'مناطق التوزيع',
        subtitle: '${_countType('مناطق التوزيع')} نتيجة',
        icon: Icons.local_shipping_rounded,
        color: const Color(0xFFE09022),
        onTap: () => onOpenSearch(type: 'مناطق التوزيع'),
      ),
      _HubCardData(
        title: 'القطاعات',
        subtitle: '${_countType('القطاعات')} نتيجة',
        icon: Icons.account_tree_rounded,
        color: const Color(0xFF7B61FF),
        onTap: () => onOpenSearch(type: 'القطاعات'),
      ),
      _HubCardData(
        title: 'المفضلة',
        subtitle: '$favoritesCount رقم محفوظ',
        icon: Icons.star_rounded,
        color: Colors.amber,
        onTap: () => onOpenSearch(query: ''),
      ),
      _HubCardData(
        title: 'آخر بحث',
        subtitle:
            recentSearches.isEmpty ? 'لا يوجد بحث بعد' : recentSearches.first,
        icon: Icons.history_rounded,
        color: const Color(0xFF546E7A),
        onTap: () {
          if (recentSearches.isNotEmpty) {
            onOpenSearch(query: recentSearches.first);
          } else {
            onOpenSearch();
          }
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('الأقسام السريعة')),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [AppColors.green, AppColors.darkGreen],
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Row(
                children: [
                  const _LogoMark(size: 68),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'من تبحث عنه اليوم؟',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '',
                          style: TextStyle(
                            color: Colors.white.withOpacity(.82),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverLayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.crossAxisExtent;
              final columns = width < 360 ? 1 : 2;
              final cardHeight = width < 360 ? 132.0 : 155.0;

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverGrid.builder(
                  itemCount: cards.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    mainAxisExtent: cardHeight,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    final card = cards[index];

                    return _HubCard(data: card);
                  },
                ),
              );
            },
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
              child: FilledButton.icon(
                onPressed: () => onOpenSearch(),
                icon: const Icon(Icons.search_rounded),
                label: const Text('فتح البحث السريع'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HubCardData {
  _HubCardData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
}

class _HubCard extends StatelessWidget {
  const _HubCard({required this.data});

  final _HubCardData data;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(26),
      onTap: data.onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF10241C) : Colors.white,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: isDark ? Colors.white.withOpacity(.08) : AppColors.border,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x10006B48),
              blurRadius: 18,
              offset: Offset(0, 9),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: data.color.withOpacity(.13),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(data.icon, color: data.color, size: 28),
            ),
            const Spacer(),
            Text(
              data.title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              data.subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.greyText),
            ),
          ],
        ),
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({
    super.key,
    required this.all,
    required this.favorites,
    required this.onToggleFavorite,
    required this.onOpenDetails,
  });

  final List<CiscoEntry> all;
  final Set<int> favorites;
  final Future<void> Function(CiscoEntry entry) onToggleFavorite;
  final void Function(CiscoEntry entry) onOpenDetails;

  @override
  Widget build(BuildContext context) {
    final items = all.where((e) => favorites.contains(e.id)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('المفضلة')),
      body: items.isEmpty
          ? const _FavoritesEmpty()
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = items[index];

                return _ResultCard(
                  entry: item,
                  isFavorite: true,
                  onTap: () => onOpenDetails(item),
                  onFavoriteTap: () => onToggleFavorite(item),
                );
              },
            ),
    );
  }
}

class _FavoritesEmpty extends StatelessWidget {
  const _FavoritesEmpty();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star_border_rounded, size: 72, color: AppColors.green),
            SizedBox(height: 14),
            Text(
              'لا توجد أرقام في المفضلة',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            SizedBox(height: 8),
            Text(
              'اضغط على علامة النجمة بجانب أي نتيجة لحفظها هنا.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.greyText),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.total,
    required this.favoritesCount,
    required this.recentCount,
    required this.recentSearches,
    required this.onClearRecent,
  });

  final int total;
  final int favoritesCount;
  final int recentCount;
  final List<String> recentSearches;
  final VoidCallback onClearRecent;

  void _showRecentSearches(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 8,
              bottom: MediaQuery.of(context).padding.bottom + 22,
            ),
            child: recentSearches.isEmpty
                ? const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.history_rounded,
                        color: AppColors.green,
                        size: 54,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'لا توجد عمليات بحث بعد',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'أي كلمة تبحث عنها ستظهر هنا بعد الضغط على زر البحث من لوحة المفاتيح.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.greyText),
                      ),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'آخر عمليات البحث',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Flexible(
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: recentSearches.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final item = recentSearches[index];

                            return ListTile(
                              leading: const Icon(
                                Icons.history_rounded,
                                color: AppColors.green,
                              ),
                              title: Text(
                                item,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      FilledButton.tonalIcon(
                        onPressed: () {
                          Navigator.pop(context);
                          onClearRecent();
                        },
                        icon: const Icon(Icons.delete_sweep_rounded),
                        label: const Text('مسح آخر عمليات البحث'),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = AppSettingsScope.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [AppColors.green, AppColors.darkGreen],
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            child: const Column(
              children: [
                _LogoMark(size: 86),
                SizedBox(height: 16),
                Text(
                  'Egypt Post Cisco',
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'تطبيق داخلي لتسهيل الوصول إلى أرقام السيسكو الخاصة بجهات البريد المصري.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, height: 1.5),
                ),
                SizedBox(height: 12),
                Text(
                  'اهداء من إدارة التكنولوجيا والمعلومات بمنطقة برج العرب إلى جميع موظفي البريد المصري.\n\nتنفيذ : م/ احمد نابغ موسي',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    height: 1.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            value: settings.isDarkMode,
            onChanged: settings.onThemeChanged,
            secondary: const Icon(Icons.dark_mode_rounded),
            title: const Text(
              'الوضع الليلي',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
            subtitle: const Text('تغيير شكل التطبيق للعرض الليلي.'),
          ),
          const Divider(),
          _SettingsTile(
            icon: Icons.dialpad_rounded,
            title: 'إجمالي الأرقام',
            value: '$total',
          ),
          _SettingsTile(
            icon: Icons.star_rounded,
            title: 'الأرقام المفضلة',
            value: '$favoritesCount',
          ),
          _SettingsTile(
            icon: Icons.history_rounded,
            title: 'آخر عمليات البحث',
            value: '$recentCount',
            onTap: () => _showRecentSearches(context),
          ),
          const SizedBox(height: 8),
          FilledButton.tonalIcon(
            onPressed: onClearRecent,
            icon: const Icon(Icons.delete_sweep_rounded),
            label: const Text('مسح آخر عمليات البحث'),
          ),
          const SizedBox(height: 14),
          const Text(
            'تنبيه: البيانات للاستخدام الداخلي .',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.greyText, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppColors.green),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w800),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
          if (onTap != null) ...[
            const SizedBox(width: 8),
            const Icon(Icons.chevron_left_rounded),
          ],
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.label,
    required this.value,
    this.isNumber = false,
  });

  final String label;
  final String value;
  final bool isNumber;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(.04) : AppColors.paleGreen,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(.08) : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.greyText,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value.isEmpty ? '-' : value,
            textDirection: isNumber ? TextDirection.ltr : TextDirection.rtl,
            style: TextStyle(
              fontSize: isNumber ? 26 : 16,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoMark extends StatelessWidget {
  const _LogoMark({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.12),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/images/egypt_post_logo.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.16),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(.82),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/egypt_post_logo.png',
              width: 92,
              height: 92,
            ),
            const SizedBox(height: 18),
            const Text(
              'لا توجد نتائج مطابقة',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'جرّب البحث بجزء من الاسم، أو رقم السيسكو مباشرة، أو اختر كل المناطق.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.greyText),
            ),
            const SizedBox(height: 14),
            FilledButton.tonalIcon(
              onPressed: onReset,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('إعادة ضبط البحث'),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingItem extends StatelessWidget {
  const _OnboardingItem({
    required this.icon,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.green),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: [
                TextSpan(
                  text: '$title\n',
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: text,
                  style: const TextStyle(
                    color: AppColors.greyText,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchHeaderDelegate extends SliverPersistentHeaderDelegate {
  _SearchHeaderDelegate({
    required this.child,
    required this.minHeight,
    required this.maxHeight,
  });

  final Widget child;
  final double minHeight;
  final double maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(covariant _SearchHeaderDelegate oldDelegate) {
    return oldDelegate.child != child ||
        oldDelegate.minHeight != minHeight ||
        oldDelegate.maxHeight != maxHeight;
  }
}
