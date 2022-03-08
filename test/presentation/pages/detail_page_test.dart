import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:how_far_from_metide/data/models/country_model.dart';
import 'package:how_far_from_metide/presentation/bloc/detail_bloc.dart';
import 'package:how_far_from_metide/domain/entities/country.dart';
import 'package:how_far_from_metide/presentation/pages/detail_page.dart';
import 'package:mocktail/mocktail.dart';

import '../../fixtures/fixture_reader.dart';

class MockDetailBloc extends MockBloc<DetailEvent, DetailState>
    implements DetailBloc {}

void main() {
  final Country tCountry =
      CountryModel.fromJson(jsonDecode(fixture("afghanistan_country.json")));
  const String tNoteText = "example note text";

  testWidgets(
    "should show the country name as the title",
    (WidgetTester tester) async {
      // arrange
      DetailBloc mockBloc = MockDetailBloc();
      whenListen(mockBloc, Stream.fromIterable(<DetailState>[]),
          initialState: DetailInitialState());
      await tester.pumpWidget(createWidgetForTesting(
          DetailPage(bloc: mockBloc, country: tCountry)));
      //act

      // assert
      final titleFinder = find.descendant(
          of: find.byType(AppBar), matching: find.text(tCountry.name!));
      expect(titleFinder, findsOneWidget);
    },
  );

  testWidgets(
    "should show the note text in the corresponding text field",
    (WidgetTester tester) async {
      // arrange
      DetailBloc mockBloc = MockDetailBloc();
      whenListen(
          mockBloc,
          Stream.fromIterable(<DetailState>[
            DetailSetupState(tNoteText),
            DetailReadyState(false)
          ]),
          initialState: DetailInitialState());
      await tester.pumpWidget(createWidgetForTesting(
          DetailPage(bloc: mockBloc, country: tCountry)));
      // act

      // assert
      final noteFinder = find.text(tNoteText);
      expect(noteFinder, findsOneWidget);
    },
  );

  testWidgets(
    "should emit DetailNoteChanged when the note text is entered in the corresponding text field",
    (WidgetTester tester) async {
      // arrange
      DetailBloc mockBloc = MockDetailBloc();
      whenListen(mockBloc, Stream.fromIterable(<DetailState>[]),
          initialState: DetailReadyState(false));
      await tester.pumpWidget(createWidgetForTesting(
          DetailPage(bloc: mockBloc, country: tCountry)));
      // act
      await tester.enterText(find.byType(TextField), "a");
      // assert
      verify(() => mockBloc.add(DetailNoteChanged(tCountry))).called(1);
    },
  );

  testWidgets(
    "should not the show save button when the note text field is not dirty",
    (WidgetTester tester) async {
      // arrange
      DetailBloc mockBloc = MockDetailBloc();
      whenListen(mockBloc, Stream.fromIterable(<DetailState>[]),
          initialState: DetailReadyState(false));
      await tester.pumpWidget(createWidgetForTesting(
          DetailPage(bloc: mockBloc, country: tCountry)));
      // act

      // assert
      final saveButtonFinder = find.byIcon(Icons.save);
      expect(saveButtonFinder, findsNothing);
    },
  );

  testWidgets(
    "should show the save button when the note text field is dirty",
    (WidgetTester tester) async {
      // arrange
      DetailBloc mockBloc = MockDetailBloc();
      whenListen(mockBloc, Stream.fromIterable(<DetailState>[]),
          initialState: DetailReadyState(true));
      await tester.pumpWidget(createWidgetForTesting(
          DetailPage(bloc: mockBloc, country: tCountry)));
      // act

      // assert
      final saveButtonFinder = find.byIcon(Icons.save);
      expect(saveButtonFinder, findsOneWidget);
    },
  );

  testWidgets(
    "should emit DetailNoteSaved when the save button is tapped",
    (WidgetTester tester) async {
      // arrange
      DetailBloc mockBloc = MockDetailBloc();
      whenListen(mockBloc, Stream.fromIterable(<DetailState>[]),
          initialState: DetailReadyState(true));
      await tester.pumpWidget(createWidgetForTesting(
          DetailPage(bloc: mockBloc, country: tCountry)));
      // act
      await tester.enterText(find.byType(TextField), tNoteText);
      await tester.tap(find.byIcon(Icons.save));
      // assert
      verify(() => mockBloc.add(DetailNoteSaved(tCountry, tNoteText)))
          .called(1);
    },
  );
}

Widget createWidgetForTesting(DetailPage detailPage) {
  return MaterialApp(home: detailPage);
}
