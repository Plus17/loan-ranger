defmodule LoanRanger.Payment do
  @moduledoc false

  defstruct [
    :date,
    :amount
  ]

  @type t() :: %__MODULE__{
          date: Date.t(),
          amount: Money.t()
        }
end
