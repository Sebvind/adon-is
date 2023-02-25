import 'dart:async';

import 'index.dart';
import 'serializers.dart';
import 'package:built_value/built_value.dart';

part 'adon_is_app_record.g.dart';

abstract class AdonIsAppRecord
    implements Built<AdonIsAppRecord, AdonIsAppRecordBuilder> {
  static Serializer<AdonIsAppRecord> get serializer =>
      _$adonIsAppRecordSerializer;

  String? get email;

  @BuiltValueField(wireName: 'display_name')
  String? get displayName;

  @BuiltValueField(wireName: 'photo_url')
  String? get photoUrl;

  String? get uid;

  @BuiltValueField(wireName: 'created_time')
  DateTime? get createdTime;

  @BuiltValueField(wireName: 'phone_number')
  String? get phoneNumber;

  @BuiltValueField(wireName: 'edited_time')
  DateTime? get editedTime;

  String? get bio;

  @BuiltValueField(wireName: 'user_name')
  String? get userName;

  String? get password;

  bool? get isGuest;

  String? get userRole;

  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference? get ffRef;
  DocumentReference get reference => ffRef!;

  static void _initializeBuilder(AdonIsAppRecordBuilder builder) => builder
    ..email = ''
    ..displayName = ''
    ..photoUrl = ''
    ..uid = ''
    ..phoneNumber = ''
    ..bio = ''
    ..userName = ''
    ..password = ''
    ..isGuest = false
    ..userRole = '';

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('adon-is_app');

  static Stream<AdonIsAppRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<AdonIsAppRecord> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  AdonIsAppRecord._();
  factory AdonIsAppRecord([void Function(AdonIsAppRecordBuilder) updates]) =
      _$AdonIsAppRecord;

  static AdonIsAppRecord getDocumentFromData(
          Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(serializer,
          {...mapFromFirestore(data), kDocumentReferenceField: reference})!;
}

Map<String, dynamic> createAdonIsAppRecordData({
  String? email,
  String? displayName,
  String? photoUrl,
  String? uid,
  DateTime? createdTime,
  String? phoneNumber,
  DateTime? editedTime,
  String? bio,
  String? userName,
  String? password,
  bool? isGuest,
  String? userRole,
}) {
  final firestoreData = serializers.toFirestore(
    AdonIsAppRecord.serializer,
    AdonIsAppRecord(
      (a) => a
        ..email = email
        ..displayName = displayName
        ..photoUrl = photoUrl
        ..uid = uid
        ..createdTime = createdTime
        ..phoneNumber = phoneNumber
        ..editedTime = editedTime
        ..bio = bio
        ..userName = userName
        ..password = password
        ..isGuest = isGuest
        ..userRole = userRole,
    ),
  );

  return firestoreData;
}
