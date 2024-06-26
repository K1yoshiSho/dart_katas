import 'package:meta/meta.dart';

import 'package:genetic_algorithm/genetic_algorithm.dart';

double infinityFitnessFunction(List<double> values) => double.infinity;
double infinityGradeFunction(List<Individual> individuals) => double.infinity;

@immutable
class IndividualParams {
  static const FitnessFunction defaultFitnessFunction = infinityFitnessFunction;
  static const int defaultLength = 5;
  static const int defaultRandomGeneratorCeiling = 100;

  final List<double> values;
  final FitnessFunction fitnessFunction;
  final int length;
  final int randomGeneratorCeiling;

  const IndividualParams({
    this.values = const [],
    this.fitnessFunction = defaultFitnessFunction,
    this.length = defaultLength,
    this.randomGeneratorCeiling = defaultRandomGeneratorCeiling,
  });
}

@immutable
class PopulationParams {
  static const GradeFunction defaultGradeFunction = infinityGradeFunction;
  static const int defaultPopulationSize = 10;

  final List<Individual> individuals;
  final GradeFunction gradeFunction;
  final int size;

  const PopulationParams({
    this.individuals = const [],
    this.gradeFunction = defaultGradeFunction,
    this.size = defaultPopulationSize,
  });
}

class GeneticEvolverParams {
  static const double defaultRetainPercentage = 0.2;
  static const double defaultRandomSelect = 0.05;
  static const double defaultMutationPercentage = 0.01;

  final double retainPercentage;
  final double randomSelect;
  final double mutationPercentage;

  const GeneticEvolverParams({
    this.retainPercentage = defaultRetainPercentage,
    this.randomSelect = defaultRandomSelect,
    this.mutationPercentage = defaultMutationPercentage,
  });
}
