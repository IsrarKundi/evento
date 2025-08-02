import 'package:uuid/uuid.dart';

import '../../main_packages.dart';
import '../../models/userModel/user_model.dart';

Rx<UserModel?> userModelGlobal =UserModel().obs;



Uuid uuid = Uuid();



RxList<String> romaniaCities = <String>[].obs;