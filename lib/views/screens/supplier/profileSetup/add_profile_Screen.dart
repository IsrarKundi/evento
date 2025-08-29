import 'dart:io';

import 'package:event_connect/controllers/suppierControllers/profile_setup_controler.dart';
import 'package:event_connect/core/constants/app_constants.dart';
import 'package:event_connect/core/utils/image_picker_service.dart';
import 'package:event_connect/core/utils/validators.dart';
import 'package:event_connect/l10n/app_localizations.dart';
import 'package:event_connect/main.dart';
import 'package:event_connect/main_packages.dart';
import 'package:event_connect/views/widget/common_image_view_widget.dart';
import 'package:event_connect/views/widget/custom_textfield.dart';
import 'package:event_connect/views/widget/my_button.dart';
import 'package:event_connect/views/widget/my_text_widget.dart';
import 'package:event_connect/services/snackbar_service/snackbar.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class AddProfileScreen extends StatefulWidget {

  final bool isEdit;
  AddProfileScreen({super.key, this.isEdit=false});

  @override
  State<AddProfileScreen> createState() => _AddProfileScreenState();
}

class _AddProfileScreenState extends State<AddProfileScreen> {

  final ProfileSetupController controller = Get.find<ProfileSetupController>();
  String? initialCountryCode;
  String? completePhoneNumber;

  @override
  void initState() {
    if(widget.isEdit){
      controller.nameController.text = userModelGlobal.value?.fullName??"";
    }
    
    // Detect country code from saved phone number
    final savedPhone = userModelGlobal.value?.completePhoneNo ?? '';
    if (savedPhone.isNotEmpty) {
      print("savedPhone: $savedPhone");
      initialCountryCode = _getCountryCodeFromPhone(savedPhone);
      completePhoneNumber = savedPhone; // Initialize with saved phone number
      
      // Extract national number for display in the field
      final nationalNumber = _extractNationalNumber(savedPhone, initialCountryCode!);
      controller.phoneNoController.text = nationalNumber;
      print("National number extracted: $nationalNumber");
    }
    initialCountryCode ??= 'RO'; // Fallback to Romania
    
    super.initState();
  }

  String _extractNationalNumber(String completePhone, String countryCode) {
    // Get the country dial code for the detected country
    final dialCode = _getDialCodeForCountry(countryCode);
    if (dialCode != null && completePhone.startsWith(dialCode)) {
      // Remove the dial code to get national number
      return completePhone.substring(dialCode.length);
    }
    return completePhone; // Return as is if we can't extract
  }

  String? _getDialCodeForCountry(String countryCode) {
    // Reverse mapping from country code to dial code
    final dialCodeMap = {
      'AF': '+93', 'AL': '+355', 'DZ': '+213', 'AD': '+376', 'AO': '+244',
      'AR': '+54', 'AM': '+374', 'AU': '+61', 'AT': '+43', 'AZ': '+994',
      'BH': '+973', 'BD': '+880', 'BY': '+375', 'BE': '+32', 'BZ': '+501',
      'BJ': '+229', 'BT': '+975', 'BO': '+591', 'BA': '+387', 'BW': '+267',
      'BR': '+55', 'BN': '+673', 'BG': '+359', 'BF': '+226', 'BI': '+257',
      'KH': '+855', 'CM': '+237', 'US': '+1', 'CV': '+238', 'CF': '+236',
      'TD': '+235', 'CL': '+56', 'CN': '+86', 'CO': '+57', 'KM': '+269',
      'CG': '+242', 'CD': '+243', 'CK': '+682', 'CR': '+506', 'HR': '+385',
      'CU': '+53', 'CY': '+357', 'CZ': '+420', 'DK': '+45', 'DJ': '+253',
      'DM': '+1767', 'DO': '+1809', 'EC': '+593', 'EG': '+20', 'SV': '+503',
      'GQ': '+240', 'ER': '+291', 'EE': '+372', 'ET': '+251', 'FJ': '+679',
      'FI': '+358', 'FR': '+33', 'GA': '+241', 'GM': '+220', 'GE': '+995',
      'DE': '+49', 'GH': '+233', 'GR': '+30', 'GD': '+1473', 'GT': '+502',
      'GN': '+224', 'GW': '+245', 'GY': '+592', 'HT': '+509', 'HN': '+504',
      'HU': '+36', 'IS': '+354', 'IN': '+91', 'ID': '+62', 'IR': '+98',
      'IQ': '+964', 'IE': '+353', 'IL': '+972', 'IT': '+39', 'JM': '+1876',
      'JP': '+81', 'JO': '+962', 'KZ': '+7', 'KE': '+254', 'KI': '+686',
      'KP': '+850', 'KR': '+82', 'KW': '+965', 'KG': '+996', 'LA': '+856',
      'LV': '+371', 'LB': '+961', 'LS': '+266', 'LR': '+231', 'LY': '+218',
      'LI': '+423', 'LT': '+370', 'LU': '+352', 'MK': '+389', 'MG': '+261',
      'MW': '+265', 'MY': '+60', 'MV': '+960', 'ML': '+223', 'MT': '+356',
      'MH': '+692', 'MR': '+222', 'MU': '+230', 'MX': '+52', 'FM': '+691',
      'MD': '+373', 'MC': '+377', 'MN': '+976', 'ME': '+382', 'MA': '+212',
      'MZ': '+258', 'MM': '+95', 'NA': '+264', 'NR': '+674', 'NP': '+977',
      'NL': '+31', 'NZ': '+64', 'NI': '+505', 'NE': '+227', 'NG': '+234',
      'NU': '+683', 'NO': '+47', 'OM': '+968', 'PK': '+92', 'PW': '+680',
      'PA': '+507', 'PG': '+675', 'PY': '+595', 'PE': '+51', 'PH': '+63',
      'PL': '+48', 'PT': '+351', 'QA': '+974', 'RO': '+40', 'RU': '+7',
      'RW': '+250', 'WS': '+685', 'SM': '+378', 'ST': '+239', 'SA': '+966',
      'SN': '+221', 'RS': '+381', 'SC': '+248', 'SL': '+232', 'SG': '+65',
      'SK': '+421', 'SI': '+386', 'SB': '+677', 'SO': '+252', 'ZA': '+27',
      'ES': '+34', 'LK': '+94', 'SD': '+249', 'SR': '+597', 'SZ': '+268',
      'SE': '+46', 'CH': '+41', 'SY': '+963', 'TW': '+886', 'TJ': '+992',
      'TZ': '+255', 'TH': '+66', 'TG': '+228', 'TO': '+676', 'TT': '+1868',
      'TN': '+216', 'TR': '+90', 'TM': '+993', 'TV': '+688', 'UG': '+256',
      'UA': '+380', 'AE': '+971', 'GB': '+44', 'UY': '+598', 'UZ': '+998',
      'VU': '+678', 'VE': '+58', 'VN': '+84', 'YE': '+967', 'ZM': '+260',
      'ZW': '+263'
    };
    
    return dialCodeMap[countryCode];
  }

  String _getCountryCodeFromPhone(String phoneNumber) {
    // Common country codes mapping
    final countryCodeMap = {
      '+93': 'AF', '+355': 'AL', '+213': 'DZ', '+376': 'AD', '+244': 'AO',
      '+54': 'AR', '+374': 'AM', '+61': 'AU', '+43': 'AT', '+994': 'AZ',
      '+973': 'BH', '+880': 'BD', '+375': 'BY', '+32': 'BE', '+501': 'BZ',
      '+229': 'BJ', '+975': 'BT', '+591': 'BO', '+387': 'BA', '+267': 'BW',
      '+55': 'BR', '+673': 'BN', '+359': 'BG', '+226': 'BF', '+257': 'BI',
      '+855': 'KH', '+237': 'CM', '+1': 'US', '+238': 'CV', '+236': 'CF',
      '+235': 'TD', '+56': 'CL', '+86': 'CN', '+57': 'CO', '+269': 'KM',
      '+242': 'CG', '+243': 'CD', '+682': 'CK', '+506': 'CR', '+385': 'HR',
      '+53': 'CU', '+357': 'CY', '+420': 'CZ', '+45': 'DK', '+253': 'DJ',
      '+1767': 'DM', '+1809': 'DO', '+593': 'EC', '+20': 'EG', '+503': 'SV',
      '+240': 'GQ', '+291': 'ER', '+372': 'EE', '+251': 'ET', '+679': 'FJ',
      '+358': 'FI', '+33': 'FR', '+241': 'GA', '+220': 'GM', '+995': 'GE',
      '+49': 'DE', '+233': 'GH', '+30': 'GR', '+1473': 'GD', '+502': 'GT',
      '+224': 'GN', '+245': 'GW', '+592': 'GY', '+509': 'HT', '+504': 'HN',
      '+36': 'HU', '+354': 'IS', '+91': 'IN', '+62': 'ID', '+98': 'IR',
      '+964': 'IQ', '+353': 'IE', '+972': 'IL', '+39': 'IT', '+1876': 'JM',
      '+81': 'JP', '+962': 'JO', '+7': 'KZ', '+254': 'KE', '+686': 'KI',
      '+850': 'KP', '+82': 'KR', '+965': 'KW', '+996': 'KG', '+856': 'LA',
      '+371': 'LV', '+961': 'LB', '+266': 'LS', '+231': 'LR', '+218': 'LY',
      '+423': 'LI', '+370': 'LT', '+352': 'LU', '+389': 'MK', '+261': 'MG',
      '+265': 'MW', '+60': 'MY', '+960': 'MV', '+223': 'ML', '+356': 'MT',
      '+692': 'MH', '+222': 'MR', '+230': 'MU', '+52': 'MX', '+691': 'FM',
      '+373': 'MD', '+377': 'MC', '+976': 'MN', '+382': 'ME', '+212': 'MA',
      '+258': 'MZ', '+95': 'MM', '+264': 'NA', '+674': 'NR', '+977': 'NP',
      '+31': 'NL', '+64': 'NZ', '+505': 'NI', '+227': 'NE', '+234': 'NG',
      '+683': 'NU', '+47': 'NO', '+968': 'OM', '+92': 'PK', '+680': 'PW',
      '+507': 'PA', '+675': 'PG', '+595': 'PY', '+51': 'PE', '+63': 'PH',
      '+48': 'PL', '+351': 'PT', '+974': 'QA', '+40': 'RO', '+7': 'RU',
      '+250': 'RW', '+685': 'WS', '+378': 'SM', '+239': 'ST', '+966': 'SA',
      '+221': 'SN', '+381': 'RS', '+248': 'SC', '+232': 'SL', '+65': 'SG',
      '+421': 'SK', '+386': 'SI', '+677': 'SB', '+252': 'SO', '+27': 'ZA',
      '+34': 'ES', '+94': 'LK', '+249': 'SD', '+597': 'SR', '+268': 'SZ',
      '+46': 'SE', '+41': 'CH', '+963': 'SY', '+886': 'TW', '+992': 'TJ',
      '+255': 'TZ', '+66': 'TH', '+228': 'TG', '+676': 'TO', '+1868': 'TT',
      '+216': 'TN', '+90': 'TR', '+993': 'TM', '+688': 'TV', '+256': 'UG',
      '+380': 'UA', '+971': 'AE', '+44': 'GB', '+598': 'UY', '+998': 'UZ',
      '+678': 'VU', '+58': 'VE', '+84': 'VN', '+967': 'YE', '+260': 'ZM',
      '+263': 'ZW'
    };

    // Try to match country codes from longest to shortest
    final sortedCodes = countryCodeMap.keys.toList()
      ..sort((a, b) => b.length.compareTo(a.length));
    
    for (String code in sortedCodes) {
      if (phoneNumber.startsWith(code)) {
        return countryCodeMap[code]!;
      }
    }
    
    return 'RO'; // Default fallback
  }

  Future<void> _saveProfile() async {
    print("Saving profile with completePhoneNumber: $completePhoneNumber");
    
    // Use complete phone number with country code if available
    final phoneToSave = completePhoneNumber ?? '';
    
    if (phoneToSave.isEmpty) {
      CustomSnackBars.instance.showFailureSnackbar(
        title: "Error", 
        message: "Please enter a valid phone number"
      );
      return;
    }
    
    // Temporarily set the phone number in controller for the save operation
    final originalPhone = controller.phoneNoController.text;
    controller.phoneNoController.text = phoneToSave;
    
    print("Phone to save: $phoneToSave");
    
    // Call the original addProfile method
    await controller.addProfile(context: context);
    
    // Restore original text
    controller.phoneNoController.text = originalPhone;
  }

  final GlobalKey<FormState> _formKey = GlobalKey();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back,
            color: kPrimaryColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Obx(()=>

                        controller.imagePath.isNotEmpty?
                        CommonImageView(
                          radius: 100,
                          height: 110,
                          width: 115,
                          file: File(controller.imagePath.value),
                          // imagePath: Assets.imagesAvatar,
                        ):
                        CommonImageView(
                        radius: 100,
                        height: 110,
                        width: 115,
                        url: controller.profileImageUrl.value,
                        // imagePath: Assets.imagesAvatar,
                      ),
                    ),
                    Positioned(
                        bottom: -10,
                        right: 0,
                        child: GestureDetector(
                            onTap: () {
                              ImagePickerService.instance
                                  .openProfilePickerBottomSheet(
                                context: context,
                                onCameraPick: () {
                                  controller.selectImage(isCamera: true);
                                },
                                onGalleryPick: () {
                                  controller.selectImage();
                                },
                              );
                              print("Button pressed");
                            },
                            child:
                                CircleAvatar(child: Icon(Icons.add_a_photo))))
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomTextField(
                  controller: controller.nameController,
                  validator: (value) => ValidationService.instance.emptyValidator(value, context),
                  labelText: AppLocalizations.of(context)!.fullName,
                  hintText: AppLocalizations.of(context)!.enterName,
                  radius: 100,
                  bottom: 10,
                ),
                CustomTextField(
                  controller: controller.emailController,
                  readOnly: true,
                  labelText: AppLocalizations.of(context)!.email,
                  hintText: AppLocalizations.of(context)!.enterEmail,
                  radius: 100,
                  bottom: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        MyText(
                          paddingBottom: 7,
                          text: AppLocalizations.of(context)!.phoneNumber,
                          size: 14,
                          weight: FontWeight.w600,
                          color: kBlackColor1,
                        ),
                        MyText(
                          paddingBottom: 7,
                          text: "*",
                          size: 12,
                          weight: FontWeight.w500,
                          color: kTertiaryColor,
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: IntlPhoneField(
                        // Use controller to set the national number part
                        controller: controller.phoneNoController,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.enterPhoneNumber,
                          hintStyle: TextStyle(
                            color: kGreyColor1,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontFamily: AppFonts.Poppins,
                          ),
                          filled: true,
                          fillColor: kWhiteColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide: BorderSide(color: kBlackColor1, width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide: BorderSide(color: kBlackColor1, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide: BorderSide(color: kSecondaryColor, width: 1),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide: BorderSide(color: kLightRedColor, width: 1),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide: BorderSide(color: kTertiaryColor, width: 1.5),
                          ),
                          errorStyle: TextStyle(fontSize: 9),
                          contentPadding: EdgeInsets.only(
                            left: 22,
                            bottom: 0,
                            top: 0,
                            right: 0,
                          ),
                        ),
                        style: TextStyle(
                          color: kBlackColor1,
                        ),
                        // Use detected country code from saved phone number
                        initialCountryCode: initialCountryCode,
                        autovalidateMode: AutovalidateMode.disabled,
                        showDropdownIcon: true,
                        flagsButtonPadding: EdgeInsets.only(left: 15),
                        onChanged: (phone) {
                          // Save the complete phone number with country code
                          completePhoneNumber = phone.completeNumber;
                          print("Phone changed: ${phone.completeNumber}");
                        },
                        validator: (phone) {
                          if (phone == null || phone.number.isEmpty) {
                            return ValidationService.instance.emptyValidator(null, context);
                          }
                          // Check if phone number starts with 0
                          if (phone.number.startsWith('0')) {
                            return "Phone number cannot start with 0";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                CustomTextField(
                  controller: controller.locationController,
                   validator: (value) => ValidationService.instance.emptyValidator(value, context),
                  labelText: AppLocalizations.of(context)!.address,
                  hintText: AppLocalizations.of(context)!.enterAddress,
                  radius: 100,
                  bottom: 10,
                ),
                CustomTextField(
                  controller: controller.languageController,
                validator: (value) => ValidationService.instance.emptyValidator(value, context),
                  labelText: AppLocalizations.of(context)!.language,
                  hintText: AppLocalizations.of(context)!.enterLanguage,
                  radius: 100,
                ),
                const SizedBox(
                  height: 30,
                ),
                MyButton(
                  onTap: () {

                    if (_formKey.currentState!.validate()) {
                      _saveProfile();
                    }
                  },
                  buttonText: AppLocalizations.of(context)!.save,
                  radius: 100,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
