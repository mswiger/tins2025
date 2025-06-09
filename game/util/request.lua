local function requestText(request)
  return request.layers .. " layers plz"
end

return {
  requestText = requestText,
}
