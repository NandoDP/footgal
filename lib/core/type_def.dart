import 'package:footgal/core/faillure.dart';
import 'package:fpdart/fpdart.dart';

typedef FutureEither<T> = Future<Either<Faillure, T>>;
typedef FutureVoid = FutureEither<void>;
