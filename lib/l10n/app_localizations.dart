import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ro.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ro')
  ];

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'Field is required'**
  String get fieldRequired;

  /// No description provided for @pleaseSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Please Select Date'**
  String get pleaseSelectDate;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email address'**
  String get pleaseEnterEmail;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get invalidEmail;

  /// No description provided for @pleaseEnterPuffs.
  ///
  /// In en, this message translates to:
  /// **'Please enter no. of puffs'**
  String get pleaseEnterPuffs;

  /// No description provided for @maximumRequired.
  ///
  /// In en, this message translates to:
  /// **'Maximum 55 required'**
  String get maximumRequired;

  /// No description provided for @pleaseEnterUsername.
  ///
  /// In en, this message translates to:
  /// **'Please enter your username'**
  String get pleaseEnterUsername;

  /// No description provided for @invalidUsername.
  ///
  /// In en, this message translates to:
  /// **'Invalid username'**
  String get invalidUsername;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters long'**
  String get passwordMinLength;

  /// No description provided for @passwordUppercase.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one uppercase letter'**
  String get passwordUppercase;

  /// No description provided for @passwordLowercase.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one lowercase letter'**
  String get passwordLowercase;

  /// No description provided for @passwordDigit.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one digit'**
  String get passwordDigit;

  /// No description provided for @passwordSpecialChar.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one special character'**
  String get passwordSpecialChar;

  /// No description provided for @pleaseEnterPasswordAgain.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password again'**
  String get pleaseEnterPasswordAgain;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @areYouSureQuitApp.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to quit app?'**
  String get areYouSureQuitApp;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @serviceArtists.
  ///
  /// In en, this message translates to:
  /// **'Artists'**
  String get serviceArtists;

  /// No description provided for @serviceEventSpaces.
  ///
  /// In en, this message translates to:
  /// **'Event Spaces'**
  String get serviceEventSpaces;

  /// No description provided for @serviceCateringCompanies.
  ///
  /// In en, this message translates to:
  /// **'Catering Companies'**
  String get serviceCateringCompanies;

  /// No description provided for @serviceInteriorDecorators.
  ///
  /// In en, this message translates to:
  /// **'Interior Decoration Companies'**
  String get serviceInteriorDecorators;

  /// No description provided for @serviceCarRental.
  ///
  /// In en, this message translates to:
  /// **'Car Rental Companies'**
  String get serviceCarRental;

  /// No description provided for @servicePhotographers.
  ///
  /// In en, this message translates to:
  /// **'Photographers'**
  String get servicePhotographers;

  /// No description provided for @serviceMakeup.
  ///
  /// In en, this message translates to:
  /// **'Makeup'**
  String get serviceMakeup;

  /// No description provided for @serviceHairdressing.
  ///
  /// In en, this message translates to:
  /// **'Hairdressing/Barber'**
  String get serviceHairdressing;

  /// No description provided for @servicePodiumLighting.
  ///
  /// In en, this message translates to:
  /// **'Podium/Lighting Setup Companies'**
  String get servicePodiumLighting;

  /// No description provided for @serviceTentRental.
  ///
  /// In en, this message translates to:
  /// **'Tent Rental Companies'**
  String get serviceTentRental;

  /// No description provided for @serviceWeddingGifts.
  ///
  /// In en, this message translates to:
  /// **'Wedding Gifts, Presents, Favors'**
  String get serviceWeddingGifts;

  /// No description provided for @serviceTailoringFashion.
  ///
  /// In en, this message translates to:
  /// **'Tailoring Workshops, Fashion, etc'**
  String get serviceTailoringFashion;

  /// No description provided for @serviceAlcoholSuppliers.
  ///
  /// In en, this message translates to:
  /// **'Alcohol Suppliers, Cigars, Bars'**
  String get serviceAlcoholSuppliers;

  /// No description provided for @serviceFlowersBouquets.
  ///
  /// In en, this message translates to:
  /// **'Flowers, Bouquets'**
  String get serviceFlowersBouquets;

  /// No description provided for @serviceOthers.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get serviceOthers;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter Email'**
  String get enterEmail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter Password'**
  String get enterPassword;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter Name'**
  String get enterName;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @oldPassword.
  ///
  /// In en, this message translates to:
  /// **'Old Password'**
  String get oldPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @againPassword.
  ///
  /// In en, this message translates to:
  /// **'Again Password'**
  String get againPassword;

  /// No description provided for @signin.
  ///
  /// In en, this message translates to:
  /// **'Signin'**
  String get signin;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Signup'**
  String get signup;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @forget.
  ///
  /// In en, this message translates to:
  /// **'Forget'**
  String get forget;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// No description provided for @addNewService.
  ///
  /// In en, this message translates to:
  /// **'Add New Service'**
  String get addNewService;

  /// No description provided for @scheduleBooking.
  ///
  /// In en, this message translates to:
  /// **'Schedule Booking'**
  String get scheduleBooking;

  /// No description provided for @post.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get post;

  /// No description provided for @goToHomepage.
  ///
  /// In en, this message translates to:
  /// **'Go to Homepage'**
  String get goToHomepage;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @selectWhatAreYou.
  ///
  /// In en, this message translates to:
  /// **'Select what are you'**
  String get selectWhatAreYou;

  /// No description provided for @forgetPassword.
  ///
  /// In en, this message translates to:
  /// **'Forget Password'**
  String get forgetPassword;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsAndConditions;

  /// No description provided for @booking.
  ///
  /// In en, this message translates to:
  /// **'Booking'**
  String get booking;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @chats.
  ///
  /// In en, this message translates to:
  /// **'Chats'**
  String get chats;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'or Continue With'**
  String get orContinueWith;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @registerNow.
  ///
  /// In en, this message translates to:
  /// **'Register Now'**
  String get registerNow;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @areYou.
  ///
  /// In en, this message translates to:
  /// **'Are You:'**
  String get areYou;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @supplier.
  ///
  /// In en, this message translates to:
  /// **'Supplier'**
  String get supplier;

  /// No description provided for @forgetPasswordQuestion.
  ///
  /// In en, this message translates to:
  /// **'Forget Password?'**
  String get forgetPasswordQuestion;

  /// No description provided for @google.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get google;

  /// No description provided for @congrats.
  ///
  /// In en, this message translates to:
  /// **'Congrats!'**
  String get congrats;

  /// No description provided for @yourBookingDone.
  ///
  /// In en, this message translates to:
  /// **'Your Booking has been Done'**
  String get yourBookingDone;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @bookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get bookings;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @past.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get past;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @doYouWantLogout.
  ///
  /// In en, this message translates to:
  /// **'Do you want to logout?'**
  String get doYouWantLogout;

  /// No description provided for @blockUser.
  ///
  /// In en, this message translates to:
  /// **'Block User'**
  String get blockUser;

  /// No description provided for @unblock.
  ///
  /// In en, this message translates to:
  /// **'Unblock'**
  String get unblock;

  /// No description provided for @cancelBooking.
  ///
  /// In en, this message translates to:
  /// **'Cancel Booking'**
  String get cancelBooking;

  /// No description provided for @deleteService.
  ///
  /// In en, this message translates to:
  /// **'Delete Service'**
  String get deleteService;

  /// No description provided for @doYouWantDeleteService.
  ///
  /// In en, this message translates to:
  /// **'Do You Want to Delete Service?'**
  String get doYouWantDeleteService;

  /// No description provided for @doYouWantCancelBooking.
  ///
  /// In en, this message translates to:
  /// **'Do you want to cancel booking?'**
  String get doYouWantCancelBooking;

  /// No description provided for @events.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get events;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select category'**
  String get selectCategory;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @event.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get event;

  /// No description provided for @boostEarningPotential.
  ///
  /// In en, this message translates to:
  /// **'Boost your earning potential'**
  String get boostEarningPotential;

  /// No description provided for @increaseEarningDescription.
  ///
  /// In en, this message translates to:
  /// **'Increase your earning potential and show clients\nwhy they need you on their team'**
  String get increaseEarningDescription;

  /// No description provided for @addBio.
  ///
  /// In en, this message translates to:
  /// **'Add Bio'**
  String get addBio;

  /// No description provided for @pleaseDescribeYourself.
  ///
  /// In en, this message translates to:
  /// **'Please describe Yourself'**
  String get pleaseDescribeYourself;

  /// No description provided for @pleaseAddBio.
  ///
  /// In en, this message translates to:
  /// **'Please Add Bio'**
  String get pleaseAddBio;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated'**
  String get lastUpdated;

  /// No description provided for @acceptanceOfTerms.
  ///
  /// In en, this message translates to:
  /// **'Acceptance of Terms'**
  String get acceptanceOfTerms;

  /// No description provided for @useOfApp.
  ///
  /// In en, this message translates to:
  /// **'Use of the App'**
  String get useOfApp;

  /// No description provided for @userAccounts.
  ///
  /// In en, this message translates to:
  /// **'User Accounts'**
  String get userAccounts;

  /// No description provided for @introduction.
  ///
  /// In en, this message translates to:
  /// **'Introduction'**
  String get introduction;

  /// No description provided for @informationWeCollect.
  ///
  /// In en, this message translates to:
  /// **'Information We Collect'**
  String get informationWeCollect;

  /// No description provided for @advertisedNow.
  ///
  /// In en, this message translates to:
  /// **'Advertised Now'**
  String get advertisedNow;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Phone Number'**
  String get enterPhoneNumber;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @enterAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter Address'**
  String get enterAddress;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @enterLanguage.
  ///
  /// In en, this message translates to:
  /// **'Enter Language'**
  String get enterLanguage;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @perHour.
  ///
  /// In en, this message translates to:
  /// **'Per Hour'**
  String get perHour;

  /// No description provided for @selectCity.
  ///
  /// In en, this message translates to:
  /// **'Select City'**
  String get selectCity;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @writeAboutServices.
  ///
  /// In en, this message translates to:
  /// **'Write about your Services'**
  String get writeAboutServices;

  /// No description provided for @describeService.
  ///
  /// In en, this message translates to:
  /// **'Describe your service here...'**
  String get describeService;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @service.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get service;

  /// No description provided for @portfolio.
  ///
  /// In en, this message translates to:
  /// **'Portfolio'**
  String get portfolio;

  /// No description provided for @bookingDetails.
  ///
  /// In en, this message translates to:
  /// **'Booking Details'**
  String get bookingDetails;

  /// No description provided for @contactNo.
  ///
  /// In en, this message translates to:
  /// **'Contact No'**
  String get contactNo;

  /// No description provided for @bookedBy.
  ///
  /// In en, this message translates to:
  /// **'Booked By'**
  String get bookedBy;

  /// No description provided for @blocked.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get blocked;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteChat.
  ///
  /// In en, this message translates to:
  /// **'Delete Chat'**
  String get deleteChat;

  /// No description provided for @doYouWantDeleteChat.
  ///
  /// In en, this message translates to:
  /// **'Do You want to delete chat?'**
  String get doYouWantDeleteChat;

  /// No description provided for @block.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get block;

  /// No description provided for @typeMessage.
  ///
  /// In en, this message translates to:
  /// **'Type Message'**
  String get typeMessage;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @chatDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Chat Deleted Successfully'**
  String get chatDeletedSuccessfully;

  /// No description provided for @bookingCancelled.
  ///
  /// In en, this message translates to:
  /// **'Booking has been cancelled'**
  String get bookingCancelled;

  /// No description provided for @bookingCancelledNotification.
  ///
  /// In en, this message translates to:
  /// **'cancel the booking'**
  String get bookingCancelledNotification;

  /// No description provided for @welcomeToEventConnect.
  ///
  /// In en, this message translates to:
  /// **'Welcome to EventConnect'**
  String get welcomeToEventConnect;

  /// No description provided for @pleaseSelectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Please select your preferred language'**
  String get pleaseSelectLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @romanian.
  ///
  /// In en, this message translates to:
  /// **'Română'**
  String get romanian;

  /// No description provided for @manageAvailability.
  ///
  /// In en, this message translates to:
  /// **'Manage Availability'**
  String get manageAvailability;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @pleaseAddPortfolio.
  ///
  /// In en, this message translates to:
  /// **'Please Add Portfolio'**
  String get pleaseAddPortfolio;

  /// No description provided for @completeAllSteps.
  ///
  /// In en, this message translates to:
  /// **'Complete All Steps'**
  String get completeAllSteps;

  /// No description provided for @addProfile.
  ///
  /// In en, this message translates to:
  /// **'Add a profile'**
  String get addProfile;

  /// No description provided for @upgradesPlan.
  ///
  /// In en, this message translates to:
  /// **'Upgrades your plan'**
  String get upgradesPlan;

  /// No description provided for @upgradePeriodMembership.
  ///
  /// In en, this message translates to:
  /// **'Upgrade the period of membership as service provider'**
  String get upgradePeriodMembership;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'yearly'**
  String get yearly;

  /// No description provided for @oneMonthFree.
  ///
  /// In en, this message translates to:
  /// **'1 month free'**
  String get oneMonthFree;

  /// No description provided for @renewAutomatically.
  ///
  /// In en, this message translates to:
  /// **'Renew automatically'**
  String get renewAutomatically;

  /// No description provided for @continueToPay.
  ///
  /// In en, this message translates to:
  /// **'Continue to pay'**
  String get continueToPay;

  /// No description provided for @advertised.
  ///
  /// In en, this message translates to:
  /// **'Advertised'**
  String get advertised;

  /// No description provided for @hi.
  ///
  /// In en, this message translates to:
  /// **'Hi'**
  String get hi;

  /// No description provided for @noAdvertisedServiceAvailable.
  ///
  /// In en, this message translates to:
  /// **'No Advertised Service Available'**
  String get noAdvertisedServiceAvailable;

  /// No description provided for @noMessagesYet.
  ///
  /// In en, this message translates to:
  /// **'No messages yet.'**
  String get noMessagesYet;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @selectTime.
  ///
  /// In en, this message translates to:
  /// **'Select Time'**
  String get selectTime;

  /// No description provided for @pleaseSelect.
  ///
  /// In en, this message translates to:
  /// **'Please Select'**
  String get pleaseSelect;

  /// No description provided for @pleaseSelectTimeAndDate.
  ///
  /// In en, this message translates to:
  /// **'Please Select Time and Date'**
  String get pleaseSelectTimeAndDate;

  /// No description provided for @doYouWantTo.
  ///
  /// In en, this message translates to:
  /// **'Do You Want to'**
  String get doYouWantTo;

  /// No description provided for @noServicesFound.
  ///
  /// In en, this message translates to:
  /// **'No Services Found'**
  String get noServicesFound;

  /// No description provided for @dateTimeAlreadyBooked.
  ///
  /// In en, this message translates to:
  /// **'Date Time Already Booked'**
  String get dateTimeAlreadyBooked;

  /// No description provided for @serviceBooked.
  ///
  /// In en, this message translates to:
  /// **'Service Booked'**
  String get serviceBooked;

  /// No description provided for @bookedYourService.
  ///
  /// In en, this message translates to:
  /// **'booked your'**
  String get bookedYourService;

  /// No description provided for @serviceAt.
  ///
  /// In en, this message translates to:
  /// **'service at'**
  String get serviceAt;

  /// No description provided for @bookingCreated.
  ///
  /// In en, this message translates to:
  /// **'Booking Created'**
  String get bookingCreated;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @doYouWantBoost.
  ///
  /// In en, this message translates to:
  /// **'Do you want a boost for your services?'**
  String get doYouWantBoost;

  /// No description provided for @payPerMonth.
  ///
  /// In en, this message translates to:
  /// **'Pay 450 lei /month'**
  String get payPerMonth;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @payForAdvertisement.
  ///
  /// In en, this message translates to:
  /// **'Pay for Advertisement'**
  String get payForAdvertisement;

  /// No description provided for @howWeUseInformation.
  ///
  /// In en, this message translates to:
  /// **'How We Use Your Information'**
  String get howWeUseInformation;

  /// No description provided for @dataSecurity.
  ///
  /// In en, this message translates to:
  /// **'Data Security'**
  String get dataSecurity;

  /// No description provided for @yourRights.
  ///
  /// In en, this message translates to:
  /// **'Your Rights'**
  String get yourRights;

  /// No description provided for @changesToPolicy.
  ///
  /// In en, this message translates to:
  /// **'Changes to This Policy'**
  String get changesToPolicy;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @intellectualProperty.
  ///
  /// In en, this message translates to:
  /// **'Intellectual Property'**
  String get intellectualProperty;

  /// No description provided for @termination.
  ///
  /// In en, this message translates to:
  /// **'Termination'**
  String get termination;

  /// No description provided for @disclaimerOfWarranty.
  ///
  /// In en, this message translates to:
  /// **'Disclaimer of Warranty'**
  String get disclaimerOfWarranty;

  /// No description provided for @limitationOfLiability.
  ///
  /// In en, this message translates to:
  /// **'Limitation of Liability'**
  String get limitationOfLiability;

  /// No description provided for @governingLaw.
  ///
  /// In en, this message translates to:
  /// **'Governing Law'**
  String get governingLaw;

  /// No description provided for @bookingDateTime.
  ///
  /// In en, this message translates to:
  /// **'Booking Date & Time'**
  String get bookingDateTime;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @noNotificationsYet.
  ///
  /// In en, this message translates to:
  /// **'No Notifications Yet'**
  String get noNotificationsYet;

  /// No description provided for @membership.
  ///
  /// In en, this message translates to:
  /// **'Membership'**
  String get membership;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @upcomingCompletedCancel.
  ///
  /// In en, this message translates to:
  /// **'Upcoming, Completed, Cancel'**
  String get upcomingCompletedCancel;

  /// No description provided for @setYourSchedule.
  ///
  /// In en, this message translates to:
  /// **'Set Your Schedule, Simplify Your Day!'**
  String get setYourSchedule;

  /// No description provided for @manageYourPortfolio.
  ///
  /// In en, this message translates to:
  /// **'Manage Your Portfolio'**
  String get manageYourPortfolio;

  /// No description provided for @advertiseYourService.
  ///
  /// In en, this message translates to:
  /// **'Advertise Your Service'**
  String get advertiseYourService;

  /// No description provided for @apple.
  ///
  /// In en, this message translates to:
  /// **'Apple'**
  String get apple;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ro'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ro':
      return AppLocalizationsRo();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
