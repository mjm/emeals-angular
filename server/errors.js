var errorMap = {
  "bad_request": 400,
  "not_found": 404,
  "conflict": 409,
  "internal_server_error": 500
};

exports.handle = function(res, err, result) {
  if (err) {
    var statusCode = errorMap[err.error];
    res.send(statusCode || 500, err);
  } else {
    res.send(200, result);
  }
};

exports.handler = function(res) {
  return function(err, result) {
    exports.handle(res, err, result);
  }
};
