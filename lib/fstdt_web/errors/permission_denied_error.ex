defmodule FstdtWeb.PermissionDeniedError do
  defexception plug_status: 404, message: "permission denied"
  def exception do
    %FstdtWeb.PermissionDeniedError{}
  end
end