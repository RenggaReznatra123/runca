const bool isProduction = false;

const String baseUrl = isProduction
    ? 'https://sys.ciptaanya.net'
    : 'https://sys.ciptaanya.net';

const String apiKey = String.fromEnvironment('API_KEY');

const String baseSocket = baseUrl;

const String baseApi = '$baseUrl/api/v1';

const String baseImage = baseUrl;
