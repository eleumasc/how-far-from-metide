import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:how_far_from_metide/presentation/bloc/detail_bloc.dart';
import 'package:how_far_from_metide/domain/entities/country.dart';
import 'package:how_far_from_metide/service_locator.dart';

class DetailPage extends StatefulWidget {
  late final DetailBloc bloc;
  final Country country;

  DetailPage({Key? key, DetailBloc? bloc, required this.country})
      : super(key: key) {
    this.bloc = bloc ?? sl<DetailBloc>();
  }

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  DetailBloc get bloc => widget.bloc;

  final TextEditingController _noteController = TextEditingController();

  Country get country => widget.country;

  @override
  void initState() {
    bloc.add(DetailNoteLoaded(country));
    super.initState();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DetailBloc, DetailState>(
      bloc: bloc,
      listener: (context, state) {
        if (state is DetailSetupState) {
          _noteController.text = state.initialNoteText;
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(country.name ?? "")),
        floatingActionButton: BlocBuilder<DetailBloc, DetailState>(
          bloc: bloc,
          builder: (context, state) => Container(
            child: state is DetailReadyState && state.dirty
                ? FloatingActionButton(
                    onPressed: () {
                      closeKeyboard();
                      bloc.add(DetailNoteSaved(country, _noteController.text));
                    },
                    child: const Icon(Icons.save),
                  )
                : null,
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: Column(
              children: [
                buildCountryDetails(context),
                buildNote(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCountryDetails(BuildContext context) {
    final headline = Theme.of(context).textTheme.headlineLarge;
    final body1 = Theme.of(context).textTheme.bodyText1;
    final body2 = Theme.of(context).textTheme.bodyText2;
    return Container(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Flexible(
                  child: Text(
                    country.name ?? "",
                    style: headline,
                  ),
                ),
              ],
            ),
          ),
          Flex(
            direction: Axis.horizontal,
            children: [
              Text(
                "Official name: ",
                style: body1,
              ),
              Flexible(
                child: Text(
                  country.officialName ?? (country.name ?? ""),
                  style: body2,
                ),
              ),
            ],
          ),
          Flex(
            direction: Axis.horizontal,
            children: [
              Text(
                "Code 2L: ",
                style: body1,
              ),
              Flexible(
                child: Text(
                  country.code2l ?? "",
                  style: body2,
                ),
              ),
            ],
          ),
          Flex(
            direction: Axis.horizontal,
            children: [
              Text(
                "Code 3L: ",
                style: body1,
              ),
              Flexible(
                child: Text(
                  country.code3l ?? "",
                  style: body2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildNote(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 255, 255, 167),
      child: Container(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: TextField(
              controller: _noteController,
              onChanged: (_) {
                bloc.add(DetailNoteChanged(country));
              },
              maxLines: 8,
              decoration: const InputDecoration.collapsed(
                hintText: "Write something...",
              ),
            ),
          ),
        ),
      ),
    );
  }

  void closeKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
