import 'dart:convert';

GetNotifState getNotifStateFromJson(String str) =>
    GetNotifState.fromJson(json.decode(str));

String getNotifStateToJson(GetNotifState data) => json.encode(data.toJson());

class GetNotifState {
  GetNotifState({
    required this.state,
  });

  bool state;

  factory GetNotifState.fromJson(Map<String, dynamic> json) => GetNotifState(
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "state": state,
      };
}
