import 'dart:async';
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:crypto/crypto.dart';
import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:intl/intl.dart';
import 'package:mca_dashboard/manager/data/data.dart';
import 'package:mca_dashboard/manager/dependencies/dependencies.dart';
import 'package:mca_dashboard/manager/redux/redux.dart';
import 'package:mca_dashboard/manager/redux/states/general/actions/approvals_action.dart';
import 'package:mca_dashboard/manager/redux/states/general/actions/checklist_templates_action.dart';
import 'package:mca_dashboard/manager/redux/states/general/actions/handover_type_action.dart';
import 'package:mca_dashboard/utils/utils.dart';
import 'package:retrofit/retrofit.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:dio/dio.dart' as dio;

import '../../../../presentation/pages/users_view/data/user_data_source.dart';
import 'actions/stocks_action.dart';

final class ErrorMd extends Equatable {
  final String message;
  final int? code;
  final dynamic data;

  const ErrorMd({
    required this.message,
    required this.code,
    required this.data,
  });

  @override
  List<Object?> get props => [message, code, data];
}

class GeneralMiddleware extends MiddlewareClass<AppState> {
  final deps = DependencyManager.instance;

  @override
  call(Store store, action, NextDispatcher next) {
    switch (action.runtimeType) {
      case GetLoginAction:
        return _getLoginAction(store.state, action);
      case GetFormatsAction:
        return _getFormatsAction(store.state, action);
      case GetClearDataAction:
        return _getClearDataAction(store.state, action);
      case GetUsersAction:
        return _getUsersAction(store.state, action);
      case GetRefreshTokenAction:
        return _getRefreshTokenAction(store.state, action);
      case GetListsAction:
        return _getListsAction(store.state, action);
      case GetInitActions:
        return _getInitActions(store.state, action);
      case GetUserReviewsAction:
        return _getUserReviewsAction(store.state, action);
      case GetCreateUserReviewAction:
        return _getCreateUserReviewAction(store.state, action);
      case GetDeleteUserReviewAction:
        return _getDeleteUserReviewAction(store.state, action);
      case GetLocationsAction:
        return _getLocationsAction(store.state, action);
      case GetStorageItemsAction:
        return _getStorageItemsAction(store.state, action);
      case GetClientsAction:
        return _getClientsAction(store.state, action);
      case GetPropertiesAction:
        return _getPropertiesAction(store.state, action);
      case GetQuotesAction:
        return _getQuotesAction(store.state, action);
      case GetWarehousesAction:
        return _getWarehousesAction(store.state, action);
      case GetCompanyInfoAction:
        return _getCompanyInfoAction(store.state, action);
      case GetAllocationsAction:
        return _getAllocationsAction(store.state, action);
      case GetAppointmentAction:
        return _getAppointmentAction(store.state, action);
      case GetUnavailableUserListAction:
        return _getUnavailableUserListAction(store.state, action);
      case PostStorageItemAction:
        return _postStorageItemAction(store.state, action);
      case PostLocationAction:
        return _postLocationAction(store.state, action);
      case PostClientAction:
        return _postClientAction(store.state, action);
      case PostQuoteAction:
        return _postQuoteAction(store.state, action);
      case ChangeQuoteStatusAction:
        return _changeQuoteStatusAction(store.state, action);
      case SendQuoteEmailAction:
        return _sendQuoteEmailAction(store.state, action);
      case GetClientContractItemsAction:
        return _getClientContractItemsAction(store.state, action);
      case GetPropertyDetailsAction:
        return _getPropertyDetailsAction(store.state, action);
      case PostPropertyDetailsAction:
        return _postPropertyDetailsAction(store.state, action);
      case PostAllocationAction:
        return _postAllocationAction(store.state, action);
      case PostUserDetailsAction:
        return _postUserDetailsAction(store.state, action);
      case GetDetailsAction:
        return _getDetailsAction(store.state, action);
      case GetUserDetailsAction:
        return _getUserDetailsAction(store.state, action);
      case GetUserContractsAction:
        return _getUserContractsAction(store.state, action);
      case PostUserContractAction:
        return _postUserContractAction(store.state, action);
      case DeleteUserContractAction:
        return _deleteUserContractAction(store.state, action);
      case GetUserVisasAction:
        return _getUserVisasAction(store.state, action);
      case PostUserVisaAction:
        return _postUserVisaAction(store.state, action);
      case DeleteUserVisaAction:
        return _deleteUserVisaAction(store.state, action);
      case GetUserPrefShiftsAction:
        return _getUserPrefShiftsAction(store.state, action);
      case PostUserPrefShiftsAction:
        return _postUserPrefShiftsAction(store.state, action);
      case DeleteUserPrefShiftsAction:
        return _deleteUserPrefShiftsAction(store.state, action);
      case GetUserQualifAction:
        return _getUserQualifAction(store.state, action);
      case PostUserQualifAction:
        return _postUserQualifAction(store.state, action);
      case DeleteUserQualifAction:
        return _deleteUserQualifAction(store.state, action);
      case DeleteUserMobileAction:
        return _deleteUserMobileAction(store.state, action);
      case GetUserMobileAction:
        return _getUserMobileAction(store.state, action);
      case GetUserStatusAction:
        return _getUserStatusAction(store.state, action);
      case PostUserStatusAction:
        return _postUserStatusAction(store.state, action);
      case PostJobTitleAction:
        return _postJobTitleAction(store.state, action);
      case DeleteJobTitleAction:
        return _deleteJobTitleAction(store.state, action);
      case DeleteGroupAction:
        return _deleteGroupAction(store.state, action);
      case PostGroupAction:
        return _postGroupAction(store.state, action);
      case DeleteQualificationAction:
        return _deleteQualificationAction(store.state, action);
      case PostQualificationAction:
        return _postQualificationAction(store.state, action);
      case DeleteWarehouseAction:
        return _deleteWarehouseAction(store.state, action);
      case PostWarehouseAction:
        return _postWarehouseAction(store.state, action);
      case DeleteStorageItemAction:
        return _deleteStorageItemAction(store.state, action);
      case PostHandoverTypeAction:
        return _postHandoverTypeAction(store.state, action);
      case DeleteHandoverTypeAction:
        return _deleteHandoverTypeAction(store.state, action);
      case DeleteLocationAction:
        return _deleteLocationAction(store.state, action);
      case GetChecklistTemplatesAction:
        return _getChecklistTemplatesAction(store.state, action);
      case PostChecklistTemplateAction:
        return _postChecklistTemplateAction(store.state, action);
      case PostChecklistTemplateRoomAction:
        return _postChecklistTemplateRoomAction(store.state, action);
      case DeleteChecklistTemplateRoomAction:
        return _deleteChecklistTemplateRoomAction(store.state, action);
      case DeletePropertyAction:
        return _deletePropertyAction(store.state, action);
      case PostPropertyAction:
        return _postPropertyAction(store.state, action);
      case GetPropertySpecialRatesAction:
        return _getPropertySpecialRatesAction(store.state, action);
      case PostPropertySpecialRatesAction:
        return _postPropertySpecialRatesAction(store.state, action);
      case DeletePropertySpecialRateAction:
        return _deletePropertySpecialRateAction(store.state, action);
      case GetPropertyStaffAction:
        return _getPropertyStaffAction(store.state, action);
      case PostPropertyStaffAction:
        return _postPropertyStaffAction(store.state, action);
      case DeletePropertyStaffAction:
        return _deletePropertyStaffAction(store.state, action);
      case GetPropertyQualificationAction:
        return _getPropertyQualificationAction(store.state, action);
      case PostPropertyQualificationAction:
        return _postPropertyQualificationAction(store.state, action);
      case DeletePropertyQualificationAction:
        return _deletePropertyQualificationAction(store.state, action);
      case GetApprovalsAction:
        return _getApprovalsAction(store.state, action);
      case ApproveRequestAction:
        return _approveRequestAction(store.state, action);
      case GetCurrentStockListAction:
        return _getCurrentStockListAction(store.state, action);
      case AddToStockAction:
        return _addToStockAction(store.state, action);
      default:
        return next(action);
    }
  }

  Future<Either<TokenMd, ErrorMd>> _getLoginAction(
      AppState state, GetLoginAction action) async {
    return await apiCall(() async {
      final HttpResponse res = await deps.apiClient.getAccessToken(
          "password",
          deps.db.getDomain(),
          deps.db.getClientId(),
          deps.db.getClientSecret(),
          action.username,
          action.password);
      final TokenMd tokenMd = TokenMd.fromJson(res.data);
      deps.db.setAccessToken(tokenMd.accessToken);
      deps.db.setRefreshToken(tokenMd.refreshToken);
      return tokenMd;
    });
  }

  Future<Either<FormatMd, ErrorMd>> _getFormatsAction(
      AppState state, GetFormatsAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.getFormats();
      final FormatMd formatMd = FormatMd.fromJson(res.data);
      appStore.dispatch(UpdateGeneralState(formatMd: formatMd));
      return formatMd;
    });
  }

  Future<Either<void, ErrorMd>> _getClearDataAction(
      AppState state, GetClearDataAction action) async {
    return await apiCall(() async {
      await deps.db.deleteAccessToken();
      await deps.db.deleteRefreshToken();
      appStore.dispatch(const UpdateGeneralState(isReset: true));
    });
  }

  Future<Either<List<UserMd>, ErrorMd>> _getUsersAction(
      AppState state, GetUsersAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.getUsers();
      if (res.data['users'] is Map) {
        final List<UserMd> users = res.data['users'].values
            .toList()
            .map<UserMd>((user) => UserMd.fromJson(user))
            .toList();
        appStore.dispatch(UpdateGeneralState(users: users));
        return users;
      } else {
        return [];
      }
    });
  }

  Future<Either<TokenMd, ErrorMd>> _getRefreshTokenAction(
      AppState state, GetRefreshTokenAction action) async {
    return await apiCall(() async {
      final HttpResponse res = await deps.apiClient.getRefreshToken(
          "refresh_token",
          deps.db.getRefreshToken(),
          deps.db.getClientId(),
          deps.db.getClientSecret());
      final TokenMd tokenMd = TokenMd.fromJson(res.data);
      deps.db.setAccessToken(tokenMd.accessToken);
      deps.db.setRefreshToken(tokenMd.refreshToken);
      return tokenMd;
    });
  }

  Future<Either<ListMd, ErrorMd>> _getListsAction(
      AppState state, GetListsAction action) async {
    ListMd parseList(dynamic data) {
      try {
        final ListMd lists = ListMd.fromJson(data);
        return lists;
      } on TypeError catch (e) {
        Logger.e("parseList ERROR");
        Logger.e(e.toString());
        Logger.e(e.stackTrace);
        rethrow;
      }
    }

    return await apiCall(() async {
      final res = await deps.apiClient.getLists();
      final ListMd lists = parseList(res.data);
      appStore.dispatch(UpdateGeneralState(lists: lists));
      return lists;
    });
  }

  Future<Either<bool, ErrorMd>> _getInitActions(
      AppState state, GetInitActions action) async {
    return DependencyManager.instance.navigation.futureLoading(() async {
      await appStore.dispatch(const GetListsAction());
      return await apiCall(() async {
        await Future.wait([
          appStore.dispatch(const GetFormatsAction()) as Future,
          appStore.dispatch(const GetDetailsAction()) as Future,
          appStore.dispatch(const GetCompanyInfoAction()) as Future,
          appStore.dispatch(const GetPropertiesAction()) as Future,
          appStore.dispatch(const GetUsersAction()) as Future,
          appStore.dispatch(const GetClientsAction()) as Future,
          appStore.dispatch(const GetLocationsAction()) as Future,
          appStore.dispatch(const GetWarehousesAction()) as Future,
          appStore.dispatch(const GetQuotesAction()) as Future,
          appStore.dispatch(const GetStorageItemsAction()) as Future,
          appStore.dispatch(const GetChecklistTemplatesAction()) as Future,
          appStore.dispatch(const GetApprovalsAction()) as Future,
        ]);
        return true;
      });
    });
  }

  Future<Either<List<UserReviewMd>, ErrorMd>> _getUserReviewsAction(
      AppState state, GetUserReviewsAction action) async {
    return await apiCall(() async {
      final res =
          await deps.apiClient.getUserDetailsReviews(action.userId.toString());
      final List<UserReviewMd> userReviews = res.data['reviews']
          .map<UserReviewMd>((userReview) => UserReviewMd.fromJson(userReview))
          .toList();
      return userReviews;
    });
  }

  Future<Either<bool, ErrorMd>> _getCreateUserReviewAction(
      AppState state, GetCreateUserReviewAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.postUserDetailsReviews(
        (action.userId ?? 0).toString(),
        title: action.title,
        conductedBy: action.conductedBy,
        date: action.date.toApiDateWithSlash,
        notes: action.notes,
        reviewid: action.reviewid,
      );
      return res.response.statusCode == 200;
    });
  }

  Future<Either<bool, ErrorMd>> _getDeleteUserReviewAction(
      AppState state, GetDeleteUserReviewAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient
          .deleteUserDetailsReviews(action.userId.toString(), action.reviewId);
      return res.response.statusCode == 200;
    });
  }

  Future<Either<List<LocationMd>, ErrorMd>> _getLocationsAction(
      AppState state, GetLocationsAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.getLocation("0");
      final List<LocationMd> locations = res.data
          .map<LocationMd>((location) => LocationMd.fromJson(location))
          .toList();
      appStore.dispatch(UpdateGeneralState(locations: locations));
      return locations;
    });
  }

  Future<Either<List<StorageItemMd>, ErrorMd>> _getStorageItemsAction(
      AppState state, GetStorageItemsAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.getStorageItems("0");
      final List<StorageItemMd> storageItems = res.data['storageitems']
          .map<StorageItemMd>(
              (storageItem) => StorageItemMd.fromJson(storageItem))
          .toList();
      appStore.dispatch(UpdateGeneralState(storageItems: storageItems));
      return storageItems;
    });
  }

  Future<Either<List<ClientMd>, ErrorMd>> _getClientsAction(
      AppState state, GetClientsAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.getClients("0");
      final List<ClientMd> clients = res.data
          .map<ClientMd>((client) => ClientMd.fromJson(client))
          .toList();
      appStore.dispatch(UpdateGeneralState(clients: clients));
      return clients;
    });
  }

  Future<Either<List<PropertyMd>, ErrorMd>> _getPropertiesAction(
      AppState state, GetPropertiesAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.getProperties("0");
      final List<PropertyMd> properties = res.data['shifts']
          .map<PropertyMd>((client) => PropertyMd.fromJson(client))
          .toList();
      appStore.dispatch(UpdateGeneralState(properties: properties));
      return properties;
    });
  }

  Future<Either<List<QuoteMd>, ErrorMd>> _getQuotesAction(
      AppState state, GetQuotesAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.getQuotes(action.id?.toString() ?? "0",
          date: action.date?.toApiDateWithDash,
          location_id: action.locationId,
          shift_id: action.shiftId);

      final List<QuoteMd> quotes = res.data['quotes']
          .map<QuoteMd>((client) => QuoteMd.fromJson(client))
          .toList();
      if (action.id == null) {
        appStore.dispatch(UpdateGeneralState(
            quotes: quotes
              ..sort((a, b) => b.createdOn.compareTo(a.createdOn))));
      }
      return quotes;
    });
  }

  Future<Either<List<WarehouseMd>, ErrorMd>> _getWarehousesAction(
      AppState state, GetWarehousesAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.getWarehouses();
      final List<WarehouseMd> warehouses = res.data['warehouses']
              ?.map<WarehouseMd>((client) => WarehouseMd.fromJson(client))
              .toList() ??
          [];
      appStore.dispatch(UpdateGeneralState(warehouses: warehouses));
      return warehouses;
    });
  }

  Future<Either<CompanyInfoMd, ErrorMd>> _getCompanyInfoAction(
      AppState state, GetCompanyInfoAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.getCompanyInfo();
      final CompanyInfoMd companyInfo = CompanyInfoMd.fromJson(res.data);
      appStore.dispatch(UpdateGeneralState(companyInfo: companyInfo));
      final color =
          companyInfo.colourSchemaMd(state.generalState.lists.colorSchemas);
      if (color != null) {
        final primary = Color(int.parse("0xFF${color.colour1.substring(1)}"));
        final secondary = Color(int.parse("0xFF${color.colour2.substring(1)}"));
        final tertiary = Color(int.parse("0xFF${color.colour3.substring(1)}"));
        deps.appDep.appTheme.theme = deps.appDep.appTheme.theme.copyWith(
          appBarTheme: deps.appDep.appTheme.theme.appBarTheme
              .copyWith(backgroundColor: primary),
          colorScheme: deps.appDep.appTheme.theme.colorScheme.copyWith(
              primary: primary, secondary: secondary, tertiary: tertiary),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  backgroundColor: primary, foregroundColor: Colors.white)),
        );
        deps.appDep.restart();
      }
      return companyInfo;
    });
  }

  Future<Either<List<AllocationMd>, ErrorMd>> _getAllocationsAction(
      AppState state, GetAllocationsAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.getAllocations(
          action.date.toApiDateWithDash,
          action.locationId!,
          action.userId!,
          action.shiftId!,
          until: action.until?.toApiDateWithDash);
      final List<AllocationMd> list = res.data['allocations']
          .map<AllocationMd>((allocation) => AllocationMd.fromJson(allocation))
          .toList();
      appStore.dispatch(UpdateGeneralState(allocations: list));
      return list;
    });
  }

  Future<Either<List<Appointment>, ErrorMd>> _getAppointmentAction(
      AppState state, GetAppointmentAction action) async {
    return await apiCall(() async {
      final Either<List<AllocationMd>, ErrorMd> res = await appStore.dispatch(
          GetAllocationsAction(date: action.startDate, until: action.endDate));
      if (res.isRight) {
        throw res.right.message;
      } else {
        final List<AllocationMd> list = res.left;

        final formatter = DateFormat('HH:mm');
        final appointments = <Appointment>[];
        for (final AllocationMd allocation in list) {
          final pr = allocation.shiftMd(state.generalState.properties);
          final us = allocation.userMd(state.generalState.users);

          bool isAllDay = false;
          if (pr != null) {
            if (pr.startTimeOfDay?.hour == 0 &&
                pr.startTimeOfDay?.minute == 0 &&
                pr.finishTimeOfDay?.hour == 23 &&
                pr.finishTimeOfDay?.minute == 59) {
              isAllDay = true;
            }
          }
          final DateTime date = DateTime.parse(allocation.date);

          final stDate = DateTime(date.year, date.month, date.day,
              pr?.startTimeOfDay?.hour ?? 0, pr?.startTimeOfDay?.minute ?? 0);
          DateTime et = DateTime(date.year, date.month, date.day,
              pr?.finishTimeOfDay?.hour ?? 0, pr?.finishTimeOfDay?.minute ?? 0);

          bool isOpenShift = false;
          if (us == null) {
            isOpenShift = true;
          }
          StringBuffer subject = StringBuffer();

          if (isOpenShift) {
            subject.write('(Open Shift) ');
          }
          if (isAllDay) {
            subject.write("All Day - ");
          } else {
            subject.write("${formatter.format(stDate)} - ");
            subject.write("${formatter.format(et)} - ");
          }
          subject.write("${allocation.shiftName} - ");
          subject.write(allocation.locationName);

          Color generateColorFromIds(
              int shiftId, int locationId, int clientId) {
            String combinedIds = shiftId.toString() +
                locationId.toString() +
                clientId.toString();
            var bytes = utf8.encode(combinedIds);
            var hash = sha1.convert(bytes); // Using SHA1 hash function

            // Extracting the first 6 characters of the hash and converting them to an integer
            int colorValue =
                int.parse(hash.toString().substring(0, 6), radix: 16);

            // Creating a Color object from the color value
            return Color(colorValue)
                .withAlpha(0xFF); // Adding alpha value (0xFF for fully opaque)
          }

          Color objectColor = pr == null
              ? Colors.green
              : pr.clientId == null || pr.locationId == null
                  ? Colors.black54
                  : generateColorFromIds(pr.id, pr.locationId!, pr.clientId!);

          appointments.add(Appointment(
              id: allocation.id,
              startTime: stDate,
              endTime: et,
              isAllDay: isAllDay,
              subject: subject.toString(),
              color: objectColor,
              //allocation.bgColor,
              resourceIds: [
                if (isOpenShift) "OPEN",
                if (us != null) "US_${us.id}",
                if (!isOpenShift) "PR_${pr?.id}",
              ]));
        }
        return appointments;
      }
    });
  }

  Future<Either<List<UserMd>, ErrorMd>> _getUnavailableUserListAction(
      AppState state, GetUnavailableUserListAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient
          .getUnavailableUserList(action.date.toApiDateWithDash);
      final List<UserMd> users = [...state.generalState.users];
      for (final data in res.data) {
        final user =
            users.firstWhereOrNull((element) => element.id == data['userId']);
        if (user != null) {
          user.unavailability.isUnavailable = true;
          user.unavailability.reason = data['unavailable'][0]['reason'];
          user.unavailability.date =
              DateTime.parse(data['unavailable'][0]['date']);
        }
      }
      appStore.dispatch(UpdateGeneralState(users: users));
      return users;
    });
  }

  Future<Either<int, ErrorMd>> _postStorageItemAction(
      AppState state, PostStorageItemAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.postStorageItem(
        active: true,
        service: false,
        id: action.id ?? 0,
        name: action.title,
        taxId: action.taxId,
        outgoingPrice: action.outgoingPrice?.toString(),
        incomingPrice: action.price.toString(),
      );
      if (action.fetchLists) {
        await Future.wait([
          appStore.dispatch(const GetListsAction()) as Future,
          appStore.dispatch(const GetStorageItemsAction()) as Future,
        ]);
      }
      return res.data;
    });
  }

  Future<Either<int, ErrorMd>> _postLocationAction(
      AppState state, PostLocationAction action) async {
    return await apiCall(() async {
      final address = action.addressData;
      final res = await deps.apiClient.postLocation(
        id: address.locationId,
        base: false,
        timelimit: false,
        anywhere: action.anywhere,
        active: action.active,
        radius: address.radius.toString(),
        phoneFax: address.phoneFax ?? "",
        phoneLandline: address.phoneLandline ?? "",
        sendChecklist: action.sendChecklist ?? address.email.isNotEmpty,
        email: address.email,
        phoneMobile: address.phoneNumber,
        name: address.name.isEmpty
            ? "${address.line1} ${address.postcode}"
            : address.name,
        addressLine1: address.line1,
        addressLine2: address.line2,
        addressCounty: address.county,
        addressCity: address.city,
        addressCountry: address.country?.code,
        addressPostcode: address.postcode,
        latitude: address.latitude.toString(),
        longitude: address.longitude.toString(),
        ipaddress: address.ipAddress,
        fixedipaddress: address.fixedIpAddress,
      );
      if (res.response.statusCode == 409) {
        throw const ErrorMd(
            message: "Location already exists", code: 409, data: null);
      }
      await Future.wait([
        appStore.dispatch(const GetListsAction()) as Future,
        appStore.dispatch(const GetLocationsAction()) as Future,
      ]);
      return res.data;
    });
  }

  Future<Either<int, ErrorMd>> _postClientAction(
      AppState state, PostClientAction action) async {
    return await apiCall(() async {
      final data = action.data;
      final addressData = action.addressData;
      final res = await deps.apiClient.postClient(data.clientId ?? 0,
          active: true,
          name: data.name,
          company: data.companyName,
          email: data.email,
          phone: data.phone,
          currencyId: data.currency!.id,
          payingDays: data.paymentDays,
          paymentMethodId: data.paymentMethod!.id,
          notes: data.notes,
          addressLine1: addressData.line1,
          addressPostcode: addressData.postcode,
          addressCountry: addressData.country!.code,
          addressCity: addressData.city);

      await Future.wait([
        appStore.dispatch(const GetListsAction()) as Future,
        appStore.dispatch(const GetClientsAction()) as Future,
      ]);
      return res.data;
    });
  }

  Future<Either<int, ErrorMd>> _postQuoteAction(
      AppState state, PostQuoteAction action) async {
    return await apiCall(() async {
      final personal = action.personalData;
      final address = action.addressData;
      final time = action.timingData;
      final products = action.productData;
      final team = action.teamData;
      final quote = action.quoteData;
      final workAddress = action.workAddressData;

      final dio.Dio apiClient = deps.dioClient.dio
        ..options.contentType = "multipart/form-data";

      final dio.FormData formData = dio.FormData();

      //Personal
      if (personal.name.isNotEmpty) {
        formData.fields.add(MapEntry('name', personal.name));
      } else {
        deps.navigation.showFail("Please enter name");
        return -1;
      }
      if (personal.companyName.isNotEmpty) {
        formData.fields.add(MapEntry('company', personal.companyName));
      }
      if (personal.email.isNotEmpty) {
        formData.fields.add(MapEntry('email', personal.email));
      } else {
        deps.navigation.showFail("Please enter email");
        return -1;
      }
      if (personal.phone.isNotEmpty) {
        formData.fields.add(MapEntry('phone', personal.phone));
      } else {
        deps.navigation.showFail("Please enter phone");
        return -1;
      }
      formData.fields
          .add(MapEntry('payingDays', personal.paymentDays.toString()));
      formData.fields.add(MapEntry('active', time.active.toString()));
      if (personal.currency != null) {
        formData.fields
            .add(MapEntry('currencyId', personal.currency!.id.toString()));
      }
      if (personal.paymentMethod != null) {
        formData.fields.add(
            MapEntry('paymentMethodId', personal.paymentMethod!.id.toString()));
      }
      if (personal.clientId != null) {
        formData.fields
            .add(MapEntry('client_id', personal.clientId!.toString()));
      }
      if (personal.notes.isNotEmpty) {
        formData.fields.add(MapEntry('notes', personal.notes));
      }
      if (personal.shiftId != null) {
        formData.fields.add(MapEntry('shift_id', personal.shiftId.toString()));
      }

      //Address
      if (address.line1.isNotEmpty) {
        formData.fields.add(MapEntry('addressLine1', address.line1));
      } else {
        deps.navigation.showFail("Please enter address line 1");
        return -1;
      }
      if (address.line2.isNotEmpty) {
        formData.fields.add(MapEntry('addressLine2', address.line2));
      }
      if (address.city.isNotEmpty) {
        formData.fields.add(MapEntry('addressCity', address.city));
      }
      if (address.county.isNotEmpty) {
        formData.fields.add(MapEntry('addressCounty', address.county));
      }
      if (address.postcode.isNotEmpty) {
        formData.fields.add(MapEntry('addressPostcode', address.postcode));
      }
      if (address.country != null) {
        formData.fields.add(MapEntry('addressCountry', address.country!.code));
      } else {
        deps.navigation.showFail("Please select country");
        return -1;
      }
      if (address.locationId != null) {
        formData.fields
            .add(MapEntry('location_id', address.locationId!.toString()));
      }

      // Work Address
      if (workAddress != null) {
        if (workAddress.line1.isNotEmpty) {
          formData.fields.add(MapEntry('workAddressLine1', workAddress.line1));
        }
        if (workAddress.line2.isNotEmpty) {
          formData.fields.add(MapEntry('workAddressLine2', workAddress.line2));
        }
        if (workAddress.city.isNotEmpty) {
          formData.fields.add(MapEntry('workAddressCity', workAddress.city));
        }
        if (workAddress.county.isNotEmpty) {
          formData.fields
              .add(MapEntry('workAddressCounty', workAddress.county));
        }
        if (workAddress.postcode.isNotEmpty) {
          formData.fields
              .add(MapEntry('workAddressPostcode', workAddress.postcode));
        }
        if (workAddress.country != null) {
          formData.fields
              .add(MapEntry('workAddressCountry', workAddress.country!.code));
        }
      }

      //Timing
      formData.fields
          .add(MapEntry('workStartDate', time.start!.toApiDateWithSlash));
      if (time.altStartDate != null) {
        formData.fields.add(MapEntry(
            'altWorkStartDate', time.altStartDate!.toApiDateWithSlash));
      }
      if (time.repeat != null) {
        formData.fields
            .add(MapEntry('workRepeatId', time.repeat!.id.toString()));
      } else {
        deps.navigation.showFail("Please select repeat");
        return -1;
      }
      if (time.startTime != null) {
        formData.fields
            .add(MapEntry('workStartTime', time.startTime!.toApiTime));
      } else {
        deps.navigation.showFail("Please select start time");
        return -1;
      }
      if (time.endTime != null) {
        formData.fields
            .add(MapEntry('workFinishTime', time.endTime!.toApiTime));
      } else {
        deps.navigation.showFail("Please select end time");
        return -1;
      }
      //"1,2,3,4,5" - Monday to Friday (1-7) week1 = week1Str
      //"8,9,10,11,12" - Monday to Friday (8-14) week2 = week2Str
      if (time.week1Str != null) {
        formData.fields.add(MapEntry('workDays', time.week1Str!));
        if (time.week2Str != null) {
          formData.fields.add(MapEntry('workDays2', time.week2Str!));
        }
      }

      //Team
      if (team.users.isNotEmpty) {
        ///[
        ///"user_id": 1,
        ///"special_rate": 0.5,
        ///"special_start_time": "09:00",
        /// ]
        final teamList = team.users
            .map((e) => {
                  "user_id": e.id,
                  "special_rate": e.specialPrice,
                  "special_start_time": e.specialTime?.toApiTime,
                }..removeWhere((key, value) => value == null))
            .toList();

        formData.fields.add(MapEntry('user_ids',
            "[${teamList.map((e) => jsonEncode(e)).toList().join(",")}]"));
      }

      //Products
      if (products.items(state.generalState.storageItems).isEmpty) {
        deps.navigation.showFail("Please add products");
        return -1;
      }
      for (int i = 0;
          i < products.items(state.generalState.storageItems).length;
          i++) {
        final item = products.items(state.generalState.storageItems)[i];

        formData.fields.add(MapEntry('quoteItem_$i', item.id.toString()));
        formData.fields
            .add(MapEntry('quoteQuantity_$i', item.quantity.toString()));
        formData.fields
            .add(MapEntry('quotePrice_$i', item.outgoingPrice.toString()));
        formData.fields.add(MapEntry('quoteAuto_$i', item.auto.toString()));
      }

      //Quote
      if (quote.quoteComment != null && quote.quoteComment!.isNotEmpty) {
        formData.fields.add(MapEntry('quoteComments', quote.quoteComment!));
      }

      formData.fields.removeWhere((element) => element.value == "null");

      logger(
          "FormData: ${formData.fields.map((e) => "${e.key}: ${e.value}").toList()}");

      dio.Response res = await apiClient.post('/api/fe/quotes/${quote.id ?? 0}',
          data: formData);
      //
      await Future.wait([
        appStore.dispatch(const GetListsAction()) as Future,
        appStore.dispatch(const GetQuotesAction()) as Future,
      ]);
      return res.data;
    });
  }

  Future<Either<bool, ErrorMd>> _changeQuoteStatusAction(
      AppState state, ChangeQuoteStatusAction action) async {
    return await apiCall(() async {
      final ipAddress = await getIpAddress();
      if (ipAddress == null) {
        deps.navigation.showFail("Can't get IP address");
        return false;
      }
      final browserId = getBrowserId();
      if (browserId.isEmpty) {
        deps.navigation.showFail("Can't get browser id");
        return false;
      }
      final res = await deps.apiClient.changeQuoteStatus(action.id,
          status: action.status, browser: browserId, ip_address: ipAddress);

      return res.response.statusCode == 200;
    });
  }

  Future<Either<bool, ErrorMd>> _sendQuoteEmailAction(
      AppState state, SendQuoteEmailAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.sendEmailToQuote(action.id);
      return res.response.statusCode == 200;
    });
  }

  Future<Either<List<StorageItemMd>, ErrorMd>> _getClientContractItemsAction(
      AppState state, GetClientContractItemsAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.getClientContractItems(
          action.clientId, action.shiftId, action.date.toApiDateWithDash);
      final List<StorageItemMd> items = [];
      final storageItems = [...state.generalState.storageItems];
      for (final item in res.data) {
        final found =
            storageItems.firstWhereOrNull((e) => e.id == item['itemId']);
        if (found != null) {
          items.add(
            found.copyWith(
              quantity: item['amount'],
              outgoingPrice: item['price'],
              auto: item['auto'],
            ),
          );
        }
      }
      return items;
    });
  }

  Future<Either<PropertyDetailMd, ErrorMd>> _getPropertyDetailsAction(
      AppState state, GetPropertyDetailsAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.getPropertyDetails(action.shiftId);
      print(res.data['details'].runtimeType);
      if (res.data['details'] is List) {
        throw const ErrorMd(
            message: "No Property Details found", code: null, data: null);
      } else {
        return PropertyDetailMd.fromJson(res.data['details']);
      }
    });
  }

  Future<Either<bool, ErrorMd>> _postPropertyDetailsAction(
      AppState state, PostPropertyDetailsAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.updatePropertyDetails(
        action.shiftId,
        notes: action.notes.isEmpty ? null : action.notes,
        bathrooms: action.bathrooms,
        bedrooms: action.bedrooms,
        max_sleeps: action.maxSleeps,
        min_sleeps: action.minSleeps,
      );
      return res.response.statusCode == 200;
    });
  }

  Future<Either<bool, ErrorMd>> _postAllocationAction(
      AppState state, PostAllocationAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.postAllocation(
        action.locationId ?? 0,
        action.userId ?? 0,
        action.shiftId ?? 0,
        action.date.toApiDateWithDash,
        action.action.name,
        date_until: action.date_until?.toApiDateWithDash,
        target_date: action.target_date?.toApiDateWithDash,
        target_location: action.target_location,
        target_shift: action.target_shift,
        target_user: action.target_user,
      );
      return res.response.statusCode == 200;
    });
  }

  Future<Either<bool, ErrorMd>> _postUserDetailsAction(
      AppState state, PostUserDetailsAction action) async {
    return await apiCall(() async {
      final data = action.dataSource;
      final personal = data.personal;
      final address = data.address;
      final religion = data.religion;
      final role = data.roleDepartmentLoginOptions;
      final nok = data.nextOfKin;

      final res = await deps.apiClient.postUserDetails(
        personal.id ?? 0,
        lastName: personal.lastName.text,
        firstName: personal.firstName.text,
        addressLine1: address.line1.text,
        addressCity: address.city.text,
        addressPostcode: address.postcode.text,
        group: role.department?.id,
        language: role.language?.code,
        location: role.location?.id,
        role: role.role!.code,
        title: personal.userTitle?.name,
        upass: personal.password.text.isEmpty ? null : personal.password.text,
        maritalStatus: personal.maritalStatus?.code,
        nationality: personal.nationality?.code,
        phoneLandline: personal.phoneLandline.text,
        notes: role.notes.text,
        email: personal.email.text,
        longitude: address.longitude,
        latitude: address.latitude,
        addressCounty: address.county.text,
        addressLine2: address.line2.text,
        phoneMobile: personal.phoneNumber.text,
        addressCountry: address.country?.code,
        birthday: personal.dateOfBirth?.toApiDateWithSlash,
        ethnic: religion.ethnicMd?.id,
        religion: religion.religionMd?.id,
        groupAdmin: role.isDepartmentManager ? "1" : "0",
        isActive: personal.isActive ? "1" : "0",
        locationAdmin: role.isLocationManager ? "1" : "0",
        ni: role.nationalInsuranceNumber.text,
        nokName: nok.name.text,
        nokPhone: nok.phoneNumber.text,
        nokRelation: nok.relationship.text,
        payrolCode: personal.payrollCode.text,
        loginmethods:
            role.loginMethods.map<int>((e) => e.id).toList().toString(),
      );

      final bool success = res.response.statusCode == 200;

      if (success) {
        await appStore.dispatch(const GetUsersAction());
      }
      return success;
    });
  }

  Future<Either<DetailsMd, ErrorMd>> _getDetailsAction(
      AppState state, GetDetailsAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.getDetails();
      appStore.dispatch(
          UpdateGeneralState(detailsMd: DetailsMd.fromJson(res.data)));
      return DetailsMd.fromJson(res.data);
    });
  }

  Future<Either<UserDataSource, ErrorMd>> _getUserDetailsAction(
      AppState state, GetUserDetailsAction action) async {
    return await apiCall(() async {
      final list = state.generalState.lists;
      final res = await deps.apiClient.getUserDetails(action.userId.toString());
      return UserDataSource.fromJson(
        res.data,
        languages: list.languages,
        userTitles: list.userTitles,
        countries: list.countries,
        locations: list.locations,
        roles: list.roles,
        departments: list.groups,
        ethnics: list.ethnics,
        maritalStatuses: list.maritalStatuses,
        religions: list.religions,
        loginMethods: list.loginMethods,
      );
    });
  }

  Future<Either<List<UserContractMd>, ErrorMd>> _getUserContractsAction(
      AppState state, GetUserContractsAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient
          .getUserDetailsContracts(action.userId.toString());
      try {
        return res.data['contracts']
            .map<UserContractMd>((e) => UserContractMd.fromJson(e))
            .toList();
      } catch (e) {
        Logger.e(e.toString(), tag: 'getUserContractsAction');
        return [];
      }
    });
  }

  Future<Either<bool, ErrorMd>> _postUserContractAction(
      AppState state, PostUserContractAction action) async {
    return await apiCall(() async {
      final data = action.dataSource;
      final res = await deps.apiClient.postUserDetailsContracts(
        action.userId.toString(),
        AHEonYS: data.annualHolidayEntitlementStart!.id,
        awh: int.parse(data.agreedWeeklyHoursController.text),
        contractType: data.contractType!.id,
        csd: data.contractStartDate!.toApiDateWithSlash,
        hct: data.holidayCalculationType!.id,
        jobTitle: data.jobTitle!.id,
        wdpw: data.workingDaysPerWeekController.text,
        ahe: int.parse(data.annualHolidayEntitlementController.text),
        ced: data.contractEndDate?.toApiDateWithSlash,
        contractid: data.id,
        initHolidays: data.holidaysCarriedOutController.text,
        lunchtime: data.paidLunchTimeController.text,
        lunchtimeUnpaid: data.unpaidLunchTimeController.text,
        salaryOT: double.parse(data.salaryPerHourOvertimeController.text),
        salaryPA: double.parse(data.salaryPerAnnumController.text),
        salaryPH: double.parse(data.salaryPerHourController.text),
      );
      return res.response.statusCode == 200;
    });
  }

  Future<Either<bool, ErrorMd>> _deleteUserContractAction(
      AppState state, DeleteUserContractAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.deleteUserDetailsContract(
          action.userId.toString(), action.contractId);
      return res.response.statusCode == 200;
    });
  }

  Future<Either<List<UserVisaMd>, ErrorMd>> _getUserVisasAction(
      AppState state, GetUserVisasAction action) async {
    return await apiCall(() async {
      final res =
          await deps.apiClient.getUserDetailsVisas(action.userId.toString());
      try {
        return res.data['visas']
            .map<UserVisaMd>((e) => UserVisaMd.fromJson(e))
            .toList();
      } catch (e) {
        Logger.e(e.toString(), tag: 'getUserVisasAction');
        return [];
      }
    });
  }

  Future<Either<bool, ErrorMd>> _postUserVisaAction(
      AppState state, PostUserVisaAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.postUserDetailsVisa(
        action.userId.toString(),
        visaid: action.visaId,
        documentNo: action.documentNumber,
        endDate: action.endDate.toApiDateWithSlash,
        startDate: action.startDate.toApiDateWithSlash,
        notExpire: action.hasExpireDate ? 1 : 0,
        visaTypeId: action.typeId,
        notes: action.notes,
      );
      return res.response.statusCode == 200;
    });
  }

  Future<Either<bool, ErrorMd>> _deleteUserVisaAction(
      AppState state, DeleteUserVisaAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.deleteUserDetailsVisa(
          action.userId.toString(), action.visaId.toString());
      return res.response.statusCode == 200;
    });
  }

  Future<Either<List<UserPreferredShiftMd>, ErrorMd>> _getUserPrefShiftsAction(
      AppState state, GetUserPrefShiftsAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient
          .getUserDetailsPreferredShifts(action.userId.toString());
      try {
        var r;
        if (res.data['preferredshifts'] is List) {
          r = res.data['preferredshifts'];
        } else {
          r = res.data['preferredshifts'].values.toList();
        }
        final List<UserPreferredShiftMd> list = [];
        for (var e in r) {
          for (var ea in e.values.toList()) {
            for (var eae in ea) {
              list.add(UserPreferredShiftMd.fromJson(eae));
            }
          }
        }
        return list;
      } catch (e) {
        Logger.e(e.toString(), tag: 'getUserPrefShiftsAction');
        return [];
      }
    });
  }

  Future<Either<bool, ErrorMd>> _postUserPrefShiftsAction(
      AppState state, PostUserPrefShiftsAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.postUserDetailsPreferredShift(
        action.userId.toString(),
        shiftId: action.shiftId,
        dayId: action.dayId,
        weekId: action.weekId,
        timingid: action.timingId,
      );
      return res.response.statusCode == 200;
    });
  }

  Future<Either<bool, ErrorMd>> _deleteUserPrefShiftsAction(
      AppState state, DeleteUserPrefShiftsAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.deleteUserDetailsPreferredShift(
          action.userId.toString(), action.timingid);
      return res.response.statusCode == 200;
    });
  }

  Future<Either<List<UserQualificationMd>, ErrorMd>> _getUserQualifAction(
      AppState state, GetUserQualifAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient
          .getUserDetailsQualifications(action.userId.toString());
      try {
        return res.data['qualifications']
            .map<UserQualificationMd>((e) => UserQualificationMd.fromJson(e))
            .toList();
      } catch (e) {
        Logger.e(e.toString(), tag: 'getUserQualifsAction');
        return [];
      }
    });
  }

  Future<Either<bool, ErrorMd>> _postUserQualifAction(
      AppState state, PostUserQualifAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.postUserDetailsQualifs(
        action.userId.toString(),
        achievementDate: action.achievementDate.toApiDateWithSlash,
        certificateNumber: action.certificateNumber,
        levelId: action.levelId,
        qualificationId: action.qualifId,
        comments: action.comment,
        expiryDate: action.expiryDate?.toApiDateWithSlash,
        userqualificationid: action.userQualifId,
        file: action.certificateBytes != null
            ? base64Encode(action.certificateBytes!)
            : null,
      );
      return res.response.statusCode == 200;
    });
  }

  Future<Either<bool, ErrorMd>> _deleteUserQualifAction(
      AppState state, DeleteUserQualifAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.deleteUserDetailsQualifs(
          action.userId.toString(), action.userQualifId);
      return res.response.statusCode == 200;
    });
  }

  Future<Either<bool, ErrorMd>> _deleteUserMobileAction(
      AppState state, DeleteUserMobileAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient
          .deleteUserDetailsMobile(action.userId.toString());
      print(res.response.statusCode);
      return res.response.statusCode == 200;
    });
  }

  Future<Either<Map<String, dynamic>, ErrorMd>> _getUserMobileAction(
      AppState state, GetUserMobileAction action) async {
    return await apiCall(() async {
      final res =
          await deps.apiClient.getUserDetailsMobile(action.userId.toString());
      return {
        "registered": res.data?['mobile']?['registered'] == "true",
        "date": res.data?['mobile']?['registered_on'],
      };
    });
  }

  Future<Either<UserStatusMd, ErrorMd>> _getUserStatusAction(
      AppState state, GetUserStatusAction action) async {
    return await apiCall(() async {
      final res =
          await deps.apiClient.getUserDetailsStatus(action.userId.toString());
      if (res.data['status']['status'] is String) {
        throw ErrorMd(
            message: res.data['status']['status'], code: null, data: null);
      }
      return UserStatusMd.fromJson(res.data['status']);
    });
  }

  Future<Either<bool, ErrorMd>> _postUserStatusAction(
      AppState state, PostUserStatusAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.postUserDetailsStatus(
        action.userId.toString(),
        location: action.locationId.toString(),
        status: action.statusId.toString(),
        shift: action.shiftId.toString(),
        comment: action.comments,
      );
      return res.response.statusCode == 200;
    });
  }

  Future<Either<bool, ErrorMd>> _deleteJobTitleAction(
      AppState state, DeleteJobTitleAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.deleteJobTitle(action.id);
      return res.response.statusCode == 200;
    });
  }

  Future<Either<bool, ErrorMd>> _postJobTitleAction(
      AppState state, PostJobTitleAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.postJobTitle(
        active: action.isActive,
        title: action.title,
        id: action.id ?? 0,
      );
      return res.response.statusCode == 200;
    });
  }

  Future<Either<bool, ErrorMd>> _deleteGroupAction(
      AppState state, DeleteGroupAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.deleteGroup(action.id);
      return res.response.statusCode == 200;
    });
  }

  Future<Either<bool, ErrorMd>> _postGroupAction(
      AppState state, PostGroupAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.postGroup(
        active: action.isActive,
        name: action.title,
        id: action.id ?? 0,
      );
      return res.response.statusCode == 200;
    });
  }

  Future<Either<bool, ErrorMd>> _deleteQualificationAction(
      AppState state, DeleteQualificationAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.deleteQualification(action.id);
      return res.response.statusCode == 200;
    });
  }

  Future<Either<bool, ErrorMd>> _postQualificationAction(
      AppState state, PostQualificationAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.postQualif(
        id: action.id ?? 0,
        active: true,
        title: action.title,
        expire: action.isExpire,
        levels: action.isLevel,
        comments: action.comments.isEmpty ? null : action.comments,
      );
      return res.response.statusCode == 200;
    });
  }

  Future<Either<bool, ErrorMd>> _postWarehouseAction(
      AppState state, PostWarehouseAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.postWarehouse(
        id: action.id ?? 0,
        active: true,
        name: action.name,
        contactName: action.contactName,
        sendReport: action.sendReport,
        contactEmail: action.contactEmail.isEmpty ? null : action.contactEmail,
      );
      return res.response.statusCode == 200;
    });
  }

  Future<Either<bool, ErrorMd>> _deleteWarehouseAction(
      AppState state, DeleteWarehouseAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.deleteWarehouse(action.id);
      return res.response.statusCode == 200;
    });
  }

  Future<Either<bool, ErrorMd>> _deleteStorageItemAction(
      AppState state, DeleteStorageItemAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.deleteStorageItems(action.id);
      return res.response.statusCode == 200;
    });
  }

  Future<Either<bool, ErrorMd>> _postHandoverTypeAction(
      AppState state, PostHandoverTypeAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.postHandoverTypes(
        id: action.id ?? 0,
        active: action.isActive,
        title: action.title,
      );
      return res.response.statusCode == 200;
    });
  }

  Future<Either<bool, ErrorMd>> _deleteHandoverTypeAction(
      AppState state, DeleteHandoverTypeAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.deleteHandoverTypes(action.id);
      return res.response.statusCode == 200;
    });
  }

  Future<Either<bool, ErrorMd>> _deleteLocationAction(
      AppState state, DeleteLocationAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.deleteLocation(action.id);
      return res.response.statusCode == 200;
    });
  }

  Future<Either<List<ChecklistTemplateMd>, ErrorMd>>
      _getChecklistTemplatesAction(
          AppState state, GetChecklistTemplatesAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.getChecklistTemplates(0);
      try {
        final list = res.data
            .map<ChecklistTemplateMd>((e) => ChecklistTemplateMd.fromJson(e))
            .toList();
        appStore.dispatch(UpdateGeneralState(checklistTemplates: list));
        return list;
      } catch (e) {
        Logger.e(e.toString(), tag: '_getChecklistTemplatesAction');
        return [];
      }
    });
  }

  Future<Either<int?, ErrorMd>> _postChecklistTemplateAction(
      AppState state, PostChecklistTemplateAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.postChecklistTemplate(
        id: action.id ?? 0,
        title: action.title,
        name: action.name,
        active: action.active,
      );
      return res.data is num ? res.data : null;
    });
  }

  Future<Either<bool, ErrorMd>> _postChecklistTemplateRoomAction(
      AppState state, PostChecklistTemplateRoomAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.postChecklistTemplateRoom(
        id: action.checklistTemplateId,
        name: action.name,
        damages: action.damage,
        items: action.items.map((e) => e).join("|"),
      );
      return res.response.statusCode == 200;
    });
  }

  Future<Either<bool, ErrorMd>> _deleteChecklistTemplateRoomAction(
      AppState state, DeleteChecklistTemplateRoomAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.deleteChecklistTemplateRoom(
          action.checklistTemplateId, action.checklistTemplateRoomName);
      return res.response.statusCode == 200;
    });
  }

  Future<Either<bool, ErrorMd>> _deletePropertyAction(
      AppState state, DeletePropertyAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.deleteProperty(action.id);
      return res.response.statusCode == 200;
    });
  }

  Future<Either<int?, ErrorMd>> _postPropertyAction(
      AppState state, PostPropertyAction action) async {
    return await apiCall(() async {
      final data = action.model;
      final res = await deps.apiClient.postPropertie(
        id: data.id ?? 0,
        title: data.propertyName.text,
        active: data.active,
        locationId: data.locationId!,
        clientId: data.clientId ?? 0,
        templateId: data.checklistTemplateId ?? 0,
        storageId: data.warehouseId ?? 0,
        checklist: data.checklistTemplateId != null,
        dayMon: data.weekDays.monday,
        dayTue: data.weekDays.tuesday,
        dayWed: data.weekDays.wednesday,
        dayThu: data.weekDays.thursday,
        dayFri: data.weekDays.friday,
        daySat: data.weekDays.saturday,
        daySun: data.weekDays.sunday,
        finishTime: data.endTime!.toApiTime,
        startTime: data.startTime!.toApiTime,
        strictBreak: data.strictBreakTime,
        startBreak: data.breakStartTime?.toApiTime,
        finishBreak: data.breakEndTime?.toApiTime,
        fpStartTime: data.mobileStartTime?.toApiTime,
        fpFinishTime: data.mobileEndTime?.toApiTime,
        fpFinishBreak: data.mobileBreakEndTime?.toApiTime,
        fpStartBreak: data.mobileBreakStartTime?.toApiTime,
      );
      return res.data is! num ? null : res.data;
    });
  }

  //GetPropertySpecialRatesAction
  Future<Either<List<SpecialRateMd>, ErrorMd>> _getPropertySpecialRatesAction(
      AppState state, GetPropertySpecialRatesAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.getPropertySpecialRate(action.shiftId);
      try {
        final list = res.data['special_rates']
            .map<SpecialRateMd>((e) => SpecialRateMd(
                  id: e['id'],
                  splitTime: e['splitTime'],
                  name: e['name'],
                  minWorkTime: e['minWorkTime'],
                  paidTime: e['minPaidTime'],
                  rate: e['rate'],
                ))
            .toList();
        return list;
      } catch (e) {
        Logger.e(e.toString(), tag: '_getPropertySpecialRatesAction');
        return [];
      }
    });
  }

  //PostPropertySpecialRatesAction
  Future<Either<bool, ErrorMd>> _postPropertySpecialRatesAction(
      AppState state, PostPropertySpecialRatesAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.postPropertySpecialRate(
        shiftId: action.shiftId,
        minPaidTime: int.parse(action.rate.minPaidTime.text),
        name: action.rate.name.text,
        minWorkTime: int.parse(action.rate.minWorkTime.text),
        rate: double.parse(action.rate.rate.text),
        splitTime: action.rate.splitTime,
      );
      return res.response.statusCode == 200;
    });
  }

  //DeletePropertySpecialRatesAction
  Future<Either<bool, ErrorMd>> _deletePropertySpecialRateAction(
      AppState state, DeletePropertySpecialRateAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient
          .deletePropertySpecialRate(action.shiftId, action.rateId);
      return res.response.statusCode == 200;
    });
  }

  //GetPropertyStaffAction
  Future<Either<List<PropertyStaffMd>, ErrorMd>> _getPropertyStaffAction(
      AppState state, GetPropertyStaffAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.getPropertyStaff(action.shiftId);
      try {
        final list = res.data['staff_requirements']
                ?.map<PropertyStaffMd>((e) => PropertyStaffMd.fromJson(e))
                .toList() ??
            <PropertyStaffMd>[];
        return list;
      } catch (e) {
        Logger.e(e.toString(), tag: '_getPropertyStaffAction');
        return [];
      }
    });
  }

  //PostPropertyStaffAction
  Future<Either<bool, ErrorMd>> _postPropertyStaffAction(
      AppState state, PostPropertyStaffAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.postPropertyStaff(
        id: action.shiftId,
        groupId: action.groupId ?? 0,
        maxOfStaff: action.maxOfStaff,
        numberOfStaff: action.minOfStaff,
      );
      return res.response.statusCode == 200;
    });
  }

  //DeletePropertyStaffAction
  Future<Either<bool, ErrorMd>> _deletePropertyStaffAction(
      AppState state, DeletePropertyStaffAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient
          .deletePropertyStaff(action.shiftId, action.groupId);
      return res.response.statusCode == 200;
    });
  }

  //GetPropertyQualificationAction
  Future<Either<List<PropertyQualificationMd>, ErrorMd>>
      _getPropertyQualificationAction(
          AppState state, GetPropertyQualificationAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.getPropertyQualification(action.shiftId);
      try {
        final list = res.data['qualification_requirements']
                ?.map<PropertyQualificationMd>(
                    (e) => PropertyQualificationMd.fromJson(e))
                .toList() ??
            <PropertyQualificationMd>[];
        return list;
      } catch (e) {
        Logger.e(e.toString(), tag: '_getPropertyQualificationAction');
        return [];
      }
    });
  }

  //PostPropertyQualificationAction
  Future<Either<bool, ErrorMd>> _postPropertyQualificationAction(
      AppState state, PostPropertyQualificationAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.postPropertyQualification(
        id: action.shiftId,
        qualificationId: action.qualificationId ?? 0,
        numberOfStaff: action.numberOfStaff,
        levelId: action.levelId ?? 0,
      );
      return res.response.statusCode == 200;
    });
  }

  //DeletePropertyQualificationAction
  Future<Either<bool, ErrorMd>> _deletePropertyQualificationAction(
      AppState state, DeletePropertyQualificationAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient
          .deletePropertyQualification(action.shiftId, action.qualificationId);
      return res.response.statusCode == 200;
    });
  }

  //GetApprovalsAction
  Future<Either<ApprovalMd, ErrorMd>> _getApprovalsAction(
      AppState state, GetApprovalsAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.getApprovals();
      try {
        final data = ApprovalMd.fromJson(res.data);
        appStore.dispatch(UpdateGeneralState(approvals: data));
        return data;
      } catch (e) {
        Logger.e(e.toString(), tag: '_getApprovalsAction');
        return const ApprovalMd(
          releaseables: [],
          acknowledgeables: [],
          requests: [],
          problems: [],
          pendingUserQualifications: [],
          closedRequests: [],
        );
      }
    });
  }

  //ApproveRequestAction
  Future<Either<bool, ErrorMd>> _approveRequestAction(
      AppState state, ApproveRequestAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.postApprovals(
        id: action.id,
        comment: action.comment,
        status: action.isAccept,
      );
      await appStore.dispatch(const GetApprovalsAction());
      return res.response.statusCode == 200;
    });
  }

  //GetCurrentStockListAction
  Future<Either<List<StockMd>, ErrorMd>> _getCurrentStockListAction(
      AppState state, GetCurrentStockListAction action) async {
    return await apiCall(() async {
      final res = await deps.apiClient.getStockList(action.warehouseId);
      try {
        final list = res.data['stock']
                ?.map<StockMd>((e) => StockMd.fromJson(e))
                .toList() ??
            <StockMd>[];
        return list;
      } catch (e) {
        Logger.e(e.toString(), tag: '_getCurrentStockListAction');
        return [];
      }
    });
  }

  //AddToStockAction
  Future<Either<bool, ErrorMd>> _addToStockAction(
      AppState state, AddToStockAction action) async {
    return await apiCall(() async {
      final dio.Dio apiClient = deps.dioClient.dio
        ..options.contentType = "multipart/form-data";

      final dio.FormData formData = dio.FormData();

      logger("Items: {${action.itemId}: ${action.quantity}}");
      final String items = base64.encode(
          utf8.encode(jsonEncode({"${action.itemId}": "${action.quantity}"})));
      String? documentNumber;
      if (action.documentNumber != null && action.documentNumber!.isNotEmpty) {
        documentNumber =
            base64.encode(utf8.encode(jsonEncode(action.documentNumber)));
      }
      String? comment;
      if (action.comment != null && action.comment!.isNotEmpty) {
        comment = base64.encode(utf8.encode(jsonEncode(action.comment)));
      }

      formData.fields
        ..add(MapEntry('id', action.warehouseId.toString()))
        ..add(MapEntry('remove', items));

      if (documentNumber != null) {
        formData.fields.add(MapEntry('document_number', documentNumber));
      }
      if (comment != null) {
        formData.fields.add(MapEntry('comments', comment));
      }

      logger(
          "FormData: ${formData.fields.map((e) => "${e.key}: ${e.value}").toList()}",
          hint: "FormData fields <->");

      dio.Response res =
          await apiClient.post('/api/fe/stockchange', data: formData);

      logger("Response: ${res.data}", hint: "Response <->");
      return res.statusCode == 200;
    });
  }
}
