import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:sistemarecomendador/controller/skillProvider.dart';

import 'debouncer.dart';

class SkillsGrid extends StatefulWidget {
  const SkillsGrid({super.key});

  @override
  State<SkillsGrid> createState() => _SkillsGridState();
}

class _SkillsGridState extends State<SkillsGrid> {
  final _debouncer = Debouncer(milliseconds: 200);
  TextEditingController _searchController = TextEditingController();
  final searcher = HitsSearcher(
    applicationID: 'ZEOCEB1JD6',
    apiKey: 'c2681098d98d5239c7cf5d8a05527870',
    indexName: 'skills',
  );
  Stream<HitsPage> get _searchPage =>
      searcher.responses.map(HitsPage.fromResponse);

  final PagingController<int, String> _pagingController =
      PagingController(firstPageKey: 0);
  final _filterState = FilterState();
  late final _facetList = FacetList(
      searcher: searcher, filterState: _filterState, attribute: 'name');
  @override
  void initState() {
    _searchPage.listen((page) {
      if (page.pageKey == 0) {
        _pagingController.refresh();
      }
      _pagingController.appendPage(page.skills, page.nextPageKey);
    }).onError((error) => _pagingController.error = error);
    _pagingController.addPageRequestListener((pageKey) =>
        searcher.applyState((state) => state.copyWith(page: pageKey)));
    searcher.connectFilterState(_filterState);
    _filterState.filters.listen((_) => _pagingController.refresh());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SkillsProvider>(builder: (context, skillsProvider, child) {
      return Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20, bottom: 20),
            width: 1500,
            child: TextField(
              controller: _searchController,
              onChanged: (query) => {
                _debouncer.run(() => setState(() {
                      searcher
                          .applyState((state) => state.copyWith(query: query));
                      searcher.query(_searchController.text);
                      _pagingController.refresh();
                    }))
              }, // 3. Trigger search
              decoration: InputDecoration(
                icon: const Icon(
                  Icons.search,
                  color: Color(0xFF1E88E5),
                ),
                hintText:
                    'Escribe tus habilidades, ej: python, javascript, etc.',
                hintStyle: const TextStyle(
                  color: Color.fromARGB(181, 38, 38, 38),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(57, 38, 38, 38),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(181, 38, 38, 38),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(78, 38, 38, 38),
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            margin:
                const EdgeInsets.only(left: 50, right: 50, bottom: 20, top: 20),
            child: _hits(context),
          ),
        ],
      );
    });
  }

  Widget _hits(BuildContext context) {
    SkillsProvider skillsProvider = Provider.of<SkillsProvider>(context);
    return PagedGridView<int, String>(
        pagingController: _pagingController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width > 1000
                ? 15
                : MediaQuery.of(context).size.width > 800
                    ? 10
                    : MediaQuery.of(context).size.width > 600
                        ? 8
                        : 4,
            childAspectRatio: 1,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10),
        shrinkWrap: true,
        builderDelegate: PagedChildBuilderDelegate<String>(
          noItemsFoundIndicatorBuilder: (_) => const Center(
            child: Text('No se encontraron resultados'),
          ),
          itemBuilder: (_, item, __) => Container(
            width: 100,
            padding: const EdgeInsets.all(5),
            height: 100,
            decoration: BoxDecoration(
              color: skillsProvider.skills.contains(item)
                  ? Color.fromARGB(255, 141, 158, 255)
                  : const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Color.fromARGB(64, 0, 0, 0),
              ),
            ),
            child: InkWell(
              onTap: () {
                skillsProvider.addSkill(item);
                _searchController.clear();
                searcher.query('');
              },
              child: Center(
                child: Text(
                  item,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF262626),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}

// GridView.count(
//                         crossAxisCount: 12,
//                         childAspectRatio: 1.5,
//                         shrinkWrap: true,
//                         mainAxisSpacing: 10,
//                         crossAxisSpacing: 10,
//                         physics: const NeverScrollableScrollPhysics(),
//                         children: [
//                           for (final hit in hits)
//                             Container(
//                               width: 100,
//                               padding: const EdgeInsets.all(5),
//                               height: 100,
//                               decoration: BoxDecoration(
//                                 color:
//                                     skillsProvider.skills.contains(hit['name'])
//                                         ? Color.fromARGB(255, 141, 158, 255)
//                                         : const Color(0xFFFFFFFF),
//                                 borderRadius: BorderRadius.circular(10),
//                                 border: Border.all(
//                                   color: Color.fromARGB(64, 0, 0, 0),
//                                 ),
//                               ),
//                               child: InkWell(
//                                 onTap: () {
//                                   skillsProvider.addSkill(hit['name']);
//                                   _searchController.clear();
//                                   searcher.query('');
//                                 },
//                                 child: Center(
//                                   child: Text(
//                                     hit['name'],
//                                     textAlign: TextAlign.center,
//                                     style: const TextStyle(
//                                       color: Color(0xFF262626),
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                         ],
//                       ),

class HitsPage {
  const HitsPage(this.skills, this.pageKey, this.nextPageKey);

  final List<String> skills;
  final int pageKey;
  final int? nextPageKey;

  factory HitsPage.fromResponse(SearchResponse response) {
    final List<String> skills =
        response.hits.map((hit) => hit['name'].toString()).toList();
    final isLastPage = response.page >= response.nbPages;
    final nextPageKey = isLastPage ? null : response.page + 1;
    return HitsPage(skills, response.page, nextPageKey);
  }
}
