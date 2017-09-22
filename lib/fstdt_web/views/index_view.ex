defmodule FstdtWeb.IndexView do
  use FstdtWeb, :view

  def page_title(:index, _params) do
    "Fundies Say the Darndest Things!"
  end

  def page_description(:index, _params) do
    "An archive of the most hillarious, evil, and incomprehensible \
    quotes on the net."
  end
end
