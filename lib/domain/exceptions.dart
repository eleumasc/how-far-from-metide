/// An [[Exception]] class related to some interaction with the server (e.g., bad request, not found, server error, network error, etc.).
class ServerException implements Exception {}

/// An [[Exception]] class related to some interaction with the local cache (e.g., cache miss).
class CacheException implements Exception {}
