defmodule Fstdt.SubmissionQueue do
  @moduledoc false
  use GenServer

  #@type quote :: %Fstdt.Schema.Quotes{}
  @type quote :: term
  @type nonce :: integer
  @type sync :: reference | nil

  @type state :: {:queue.queue(nonce), %{nonce => quote}, sync}

  def start_link do
    GenServer.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  @spec init(:ok) :: {:ok, state}
  def init(:ok) do
    state = :fstdt
    |> Application.get_env(:submission_queue_path)
    |> File.read()
    |> case do
         {:ok, binary} -> :erlang.binary_to_term(binary)
         _ -> {:queue.new(), %{}, nil}
       end
    {:ok, state}
  end

  @spec add_quote(nonce, quote) :: :ok
  def add_quote(nonce, quote) do
    GenServer.call(__MODULE__, {:add_quote, nonce, quote})
  end

  @spec peek_quote :: {nonce, quote} | nil
  def peek_quote do
    GenServer.call(__MODULE__, :peek_quote)
  end

  @spec pop_quote(nonce) :: quote | nil
  def pop_quote(nonce) do
    GenServer.call(__MODULE__, {:pop_quote, nonce})
  end

  ##################

  @spec handle_call({:add_quote, nonce, quote}, pid, state) :: {:reply, :ok, state}
  def handle_call({:add_quote, nonce, quote}, _from, {q, quotes, sync}) do
    state = {:queue.in_r(nonce, q), Map.put(quotes, nonce, quote), sync_(sync)}
    {:reply, :ok, state}
  end
  @spec handle_call(:peek_quote, pid, state) :: {:reply, {nonce, quote} | nil, state}
  def handle_call(:peek_quote, _from, {q, quotes, sync}) do
    {result, q, quotes} = case :queue.out(q) do
      {{:value, nonce}, q} ->
        {{nonce, quotes[nonce]}, :queue.in_r(nonce, q), quotes}
      {:empty, q} ->
        {nil, q, quotes}
    end
    {:reply, result, {q, quotes, sync_(sync)}}
  end
  @spec handle_call({:pop_quote, nonce}, pid, state) :: {:reply, quote | nil, state}
  def handle_call({:pop_quote, nonce}, _from, {q, quotes, sync}) do
    {quote, quotes} = Map.pop(quotes, nonce)
    q = :queue.filter(fn n -> n != nonce end, q)
    {:reply, quote, {q, quotes, sync_(sync)}}
  end

  @spec handle_info(:sync, state) :: {:noreply, state}
  def handle_info(:sync, {q, quotes, _sync}) do
    state = {q, quotes, nil}
    :fstdt
    |> Application.get_env(:submission_queue_path)
    |> File.write!(:erlang.term_to_binary(state))
    {:noreply, state}
  end

  # ten minutes
  defp sync_(nil), do: :timer.send_after(600_000, :sync)
  defp sync_(timer), do: timer
end
