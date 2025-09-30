class AppUrls {
  static const String APP_NAME = 'ChatBot';
  static const double APP_VERSION = 1.0;
  static const String BASE_URL =
      "https://api.carepal.in"; //;https://d32pj02ljl8jew.cloudfront.net";
  static const String login = "/api/v1/doctor/login";
  static const String signUp = "/api/v1/doctor/create_health_practioner/";
  static const String otpVerify = "/api/v1/doctor/otp_verify/";
  static const String forgetPassword = "/api/v1/auth/forget-password";
  static const String otpVerifyForgot = "/api/v1/auth/verify-otp";
  static const String changePassword = "/api/v1/auth/update-password";
  static const String chat = "/api/v1/auth/email-login";
  static const String resendOtp = "/api/v1/auth/resend-otp";
  static const String addJournal = "/api/v1/journal/create_journal";
  static const String getJournal =
      "/api/v1/journal/get_journal_by_userid/?page=1&size=100";
  static const String deleteJournal = "/api/v1/journal/delete_journal/";
  static const String journalDashboard =
      "/api/v1/journal/get_strike_dashboard_by_userid/";
  static const String aichat = "/api/v1/ai/simple_mother_ai_audio/";
  static const String taskGet = "/api/v1/task/get_task_all/";
  static const String createTask = "/api/v1/task/create_task/";
  static const String updateArrange = "/api/v1/task/update_arrange/";
  static const String startPromo = "/api/v1/pomodoro/pomodoro_entry/";
  static const String chatRage = "/api/v1/ai/rage/";
  static const String createBreath = "/api/v1/breath/create_breath/";
  static const String createRage = "/api/v1/rage/create_rage/";
  static const String profile = "/api/v1/user/update_user/";
  static const String onboard = "/api/v1/user/onboarding/";
  static const String aaudioFile = "/api/v1/ai/voice_breathing/";
  static const String create_meeting = "/api/v1/meetings/create_user/";
  static const String get_meeting = "/api/v1/dashboard/get_all_meeting";
  // Optional: Presigned AWS IoT WebSocket URL for Flutter web MQTT connections
  // Leave empty to use default endpoint (will fail without SigV4)
  static const String AWS_IOT_PRESIGNED_URL = '';
  // MQTT client identifier to use for both IO and Web
  static const String AWS_IOT_CLIENT_ID = 'flutter_client_web';
}
