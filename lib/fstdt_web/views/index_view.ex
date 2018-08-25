defmodule FstdtWeb.IndexView do
  use FstdtWeb, :view

  def page_title(:index, _params) do
    "Fundies Say the Darndest Things!"
  end

  def page_title(:login, _params) do
    "Log in"
  end

  def page_description(_, _params) do
    "An archive of the most hilarious, evil, and incomprehensible \
    quotes on the net."
  end
end
