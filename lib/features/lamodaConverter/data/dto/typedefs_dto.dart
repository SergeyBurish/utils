import 'amount_price_dto.dart';

typedef PenaltiesDto = Map<String, AmountPriceDto>; // description, AmountPrice
typedef WorkerPenaltiesDto = Map<String, PenaltiesDto>; // login, penalties