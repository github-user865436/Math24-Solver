local function GetAllSolutions(NumbersToUse, UnusedDesiredNumber)
  local function Layer(CurrentNumbers, NumberToFind, Steps)
    --print("FunctionStarted")
    local Count = #CurrentNumbers - 1
    if Count > 0 then
      local FoundNumber = false
      local PlaceHolders = {}
      local NewNumbers = {}
      local Starting = 1
      for UnusedNumberA = Starting, #CurrentNumbers + Starting do
        if UnusedNumberA > 1 then
          for UnusedNumberB = Starting, #CurrentNumbers + Starting do
            if UnusedNumberB > 1 then
              local NumberA, NumberB = UnusedNumberA - 1, UnusedNumberB - 1
              local EncryptedUsedNumbers = tostring(math.min(NumberA, NumberB))..tostring(math.max(NumberB, NumberA))
              if NumberA ~= NumberB then
                local Add = {CurrentNumbers[NumberA][1] * CurrentNumbers[NumberB][2] + CurrentNumbers[NumberA][2] * CurrentNumbers[NumberB][1], CurrentNumbers[NumberA][2] * CurrentNumbers[NumberB][2]}
                local Subtract = {CurrentNumbers[NumberA][1] * CurrentNumbers[NumberB][2] - CurrentNumbers[NumberA][2] * CurrentNumbers[NumberB][1], CurrentNumbers[NumberA][2] * CurrentNumbers[NumberB][2]}
                local Multi = {CurrentNumbers[NumberA][1] * CurrentNumbers[NumberB][1], CurrentNumbers[NumberA][2] * CurrentNumbers[NumberB][2]}
                local Divide = {CurrentNumbers[NumberA][1] * CurrentNumbers[NumberB][2], CurrentNumbers[NumberA][2] * CurrentNumbers[NumberB][1]}
                local function AddNumber(Number)
                  local FollowRule = true
                  if not FollowRule or Number[1] / Number[2] >= 0 then
                    table.insert(PlaceHolders[EncryptedUsedNumbers], Number)
                  end
                end
                if NumberA < NumberB then
                  --Forwards
                  PlaceHolders[EncryptedUsedNumbers] = {}
                  AddNumber(Add)
                  AddNumber(Multi)
                end
                --Forward OR Backward
                AddNumber(Subtract)
                AddNumber(Divide)
              end
            end
          end
        end
      end
  
      for EncryptedUsedNumbers, Possibilities in pairs(PlaceHolders) do
        for _, PossibleCreation in ipairs(Possibilities) do
          local UnchangedNumbers = ""
          local NewPair = {PossibleCreation}
          FoundNumber = Count == 1 and PossibleCreation == NumberToFind
  
          local function HelpIndexFunction(Container, Action)
            local StartingPoint, EndingPoint = 1, #Container
            for i = StartingPoint, EndingPoint + StartingPoint do
              if i > StartingPoint then
                Action(i - StartingPoint, StartingPoint, EndingPoint)
              end
            end
          end
  
          if FoundNumber then
            --print(table.unpack(CurrentNumbers))
          end
          HelpIndexFunction(
            CurrentNumbers,
            function (i)
              UnchangedNumbers = UnchangedNumbers..tostring(i)
            end
          )
  
          local Changed = 0
          HelpIndexFunction(
            EncryptedUsedNumbers,
            function (i)
              HelpIndexFunction(
                UnchangedNumbers,
                function (j, StartingPoint, EndingPoint)
                  local StartOfString = string.sub(UnchangedNumbers, StartingPoint, j - 1)
                  local EndOfString = string.sub(UnchangedNumbers, j + 1, EndingPoint)
                  local UnchangedNumberString = string.sub(UnchangedNumbers, j, j)
                  local EncryptedUsedNumberString = string.sub(EncryptedUsedNumbers, i, i)
  
                  --print(Count, PossibleCreation, UnchangedNumbers, j, EncryptedUsedNumbers, i, StartingPoint, EndingPoint, UnchangedNumberString, EncryptedUsedNumberString, Changed, StartOfString, EndOfString)
                  
                  if UnchangedNumberString == EncryptedUsedNumberString and i > Changed then
                    UnchangedNumbers = StartOfString .. EndOfString
                    Changed = Changed + 1
                  end
                end
              )
            end
          )
  
          HelpIndexFunction(
            UnchangedNumbers,
            function (i)
              --if Count == 3 then print(UnchangedNumbers, i, CurrentNumbers[tonumber(string.sub(UnchangedNumbers, i, i))]) end
              local OtherNumber = string.sub(UnchangedNumbers, i, i)
              table.insert(NewPair, CurrentNumbers[tonumber(OtherNumber)])
            end
          )
  
          table.insert(NewNumbers, NewPair)
          --print(table.unpack(NewPair))
        end
      end
  
      local Nums = {}
      for _, NumberPairs in ipairs(NewNumbers) do
        local Unpacked
        if Steps then
          Unpacked = table.unpack(Steps)
        else
          Unpacked = nil
        end
        
        local RedoFunctionToFindNumbers = Layer(NumberPairs, NumberToFind, {Unpacked, CurrentNumbers})
        for _, Number in ipairs(RedoFunctionToFindNumbers) do
          table.insert(Nums, Number)
        end
      end
      return Nums
    else
      for _, V in ipairs(Steps) do
        print(V)
      end
      return CurrentNumbers
    end
  end

  local function Round(Number)
    local Floor = math.floor(Number)
    local Ceil = math.ceil(Number)

    if Number - Floor > Ceil - Number then
      return Floor
    else
      return Ceil
    end
  end
  
  local function FindNumberInATable(Number, Table)
    for _, DirectFromTableNumber in ipairs(Table) do
      if Number == DirectFromTableNumber then
        return true
      end
    end
    return false
  end

  local function RemoveValueFromIPairsTable(Value, Table)
    local TableWithValueRemoved = {}
    for _, DirectFromTableValue in ipairs(Table) do
      if Value ~= DirectFromTableValue then
        table.insert(TableWithValueRemoved, DirectFromTableValue)
      end
    end
    return TableWithValueRemoved
  end

  local function MoveValueFromOneIPairsTableToAnother(MainTable, NewTable, Value)
    local NewNewTable = NewTable
    local NewMainTable = RemoveValueFromIPairsTable(Value, MainTable)
    if MainTable ~= NewMainTable then
      table.insert(NewNewTable, Value)
    end
    return NewMainTable, NewNewTable
  end
  
  local function Add1LowestValueToANewSortIPairsTable(SortedTable, Table)
    local NewTable = Table
    local NewSortedTable = SortedTable

    local LowestValue
    for _, Value in ipairs(Table) do
      if not LowestValue or Value < LowestValue then
        LowestValue = Value
      end
    end
    
    return MoveValueFromOneIPairsTableToAnother(NewTable, NewSortedTable, LowestValue)
  end

  local function SortIPairsTable(Table)
    local SortedTable = {}
    local NewTable = Table
    local LengthOfTable = #NewTable
    for _ = 1, tonumber(LengthOfTable) do
      NewTable, SortedTable = Add1LowestValueToANewSortIPairsTable(SortedTable, NewTable)
    end
    return SortedTable
  end

  local function RemoveAllDuplicateNumbersFromATable(Table)
    local NewTable = {}
    for _, Number in ipairs(Table) do
      if not FindNumberInATable(Number, NewTable) then
        table.insert(NewTable, Number)
      end
    end
    return NewTable
  end
  
  local AllSolutions = Layer(NumbersToUse, DesiredNumber)
  
  local NowAllSolutions = {}
  for Index, Value in ipairs(AllSolutions) do
    table.insert(NowAllSolutions, Value[1] / Value[2])
  end
  NowAllSolutions = SortIPairsTable(RemoveAllDuplicateNumbersFromATable(NowAllSolutions))
  
  for Index, Value in ipairs(NowAllSolutions) do
    if math.floor(Value * 10) == Value * 10 then
            
    end
  end
  
  return NowAllSolutions
end

print(table.unpack(GetAllSolutions({{2, 1}, {2, 1}, {2, 1}, {3, 1}})))
