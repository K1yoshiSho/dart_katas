import 'dart:math';

abstract class PrimeGenerator {
  void generatePrimes();
}

class EratosSievePrimeGenerator implements PrimeGenerator {
  static final int maxUpperLimit = 1e9.toInt();
  static const String maxUpperLimitErrorMsg = 'Beyond the Maximum Upper Limit';

  final int _upperInclusiveLimit;
  List<int> _primes = [];

  EratosSievePrimeGenerator({
    required int upperInclusiveLimit,
  }) : _upperInclusiveLimit = upperInclusiveLimit <= maxUpperLimit ? upperInclusiveLimit : throw ArgumentError(maxUpperLimitErrorMsg);

  int get upperLimit => _upperInclusiveLimit;
  List<int> get primes => _primes;

  @override
  void generatePrimes() {
    final List<int> allIntegers = _generateIntegers(_upperInclusiveLimit - 1);
    final List<bool> booleanExcluders = _generateBooleanExcluders(_upperInclusiveLimit);
    final int topRange = _calculateTopRange(_upperInclusiveLimit);

    _baseLooper(topRange, (int baseOfSieve) {
      final int baseOfSieveIndex = allIntegers.indexOf(baseOfSieve);

      if (_isBaseNotExcluded(booleanExcluders, baseOfSieveIndex)) {
        _seiveLooper(baseOfSieve, (int testedInteger) {
          final int testedIntegerIndex = allIntegers.indexOf(testedInteger);
          booleanExcluders[testedIntegerIndex] = true;
        });
      }
    });

    _primes = _filterIntegers(allIntegers, booleanExcluders);
  }

  void _baseLooper(
    int topRange,
    Function(int baseOfSieve) function,
  ) {
    for (int baseOfSieve = 2; baseOfSieve < topRange; baseOfSieve++) {
      function(baseOfSieve);
    }
  }

  void _seiveLooper(
    int baseOfSieve,
    Function(int testedInteger) function,
  ) {
    for (int testedInteger = _calculateStartOfSieve(baseOfSieve); testedInteger <= _upperInclusiveLimit; testedInteger += baseOfSieve) {
      function(testedInteger);
    }
  }

  List<int> _generateIntegers(int upperInclusiveLimit) => List<int>.generate(upperInclusiveLimit, (int i) => i + 2);

  List<bool> _generateBooleanExcluders(int upperInclusiveLimit) => List<bool>.filled(upperInclusiveLimit - 1, false);

  int _calculateTopRange(int upperInclusiveLimit) => sqrt(upperInclusiveLimit).ceil() + 1;

  bool _isBaseNotExcluded(List<bool> booleanExcluders, int baseIndex) => !booleanExcluders[baseIndex];

  int _calculateStartOfSieve(int base) => pow(base, 2).toInt();

  List<int> _filterIntegers(
    List<int> allIntegers,
    List<bool> booleanExcluderFilter,
  ) =>
      allIntegers.where((int integer) {
        final int integerIndex = allIntegers.indexOf(integer);
        return !booleanExcluderFilter[integerIndex];
      }).toList();
}
