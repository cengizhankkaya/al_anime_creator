import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'help_state.dart';

class HelpCubit extends Cubit<HelpState> {
  HelpCubit() : super(HelpInitial());
}
