import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:how_far_from_metide/presentation/bloc/home_bloc.dart';
import 'package:how_far_from_metide/config.dart' as config;
import 'package:how_far_from_metide/presentation/pages/detail_page.dart';
import 'package:how_far_from_metide/service_locator.dart';

class HomePage extends StatefulWidget {
  late final HomeBloc bloc;

  HomePage({Key? key, HomeBloc? bloc}) : super(key: key) {
    this.bloc = bloc ?? sl<HomeBloc>();
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeBloc get bloc => widget.bloc;

  @override
  void initState() {
    bloc.add(HomeCountriesFetched());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(config.appTitle),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        bloc: bloc,
        builder: (context, state) {
          if (state is HomeReadyState) {
            return RefreshIndicator(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(state.countries[index].name ?? ""),
                      subtitle: state.countries[index].distance != null
                          ? Text(
                              "${state.countries[index].distance!.toStringAsFixed(0)} km")
                          : null,
                      leading: SizedBox(
                        width: 48,
                        height: 48,
                        child: CachedNetworkImage(
                          imageUrl: state.countries[index].flagUrl!,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          fit: BoxFit.contain,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailPage(country: state.countries[index]),
                          ),
                        );
                      },
                    );
                  },
                  itemCount: state.countries.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                ),
                onRefresh: () async {
                  bloc.add(HomeCountriesFetched());
                });
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
