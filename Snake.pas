program Snake;

uses GraphABC;

type 
  SnakeStruct = record
    x: integer;
    y: integer;
  end;
  
  AppleStruct = record
    x: integer;
    y: integer;
  end;

const
  MAX_SNAKE_LENGTH = 50;
  APPLES_NUM = 3;

  LEFT = 0;
  RIGHT = 1;
  UP = 3;
  DOWN = 4;
  
  ROWS_COUNT = 20;
  COLS_COUNT = 20;
  
  MAX_SPEED = 50;

var
  gameRunned : boolean;
  i: integer;
  ceilSize, snakeLength, snakeSpeed, direction: integer;
  SnakeBody: array[0..MAX_SNAKE_LENGTH] of SnakeStruct;
  Apple:  AppleStruct;
  
procedure DrawGrid();
var
  i: integer;
begin
  for i := 1 to ROWS_COUNT - 1 do 
  begin
    line(i * ceilSize, 0, i * ceilSize, Window.Height);
  end;
  
  for i := 1 to COLS_COUNT - 1 do 
  begin
    line(0, i * ceilSize, Window.Width, i * ceilSize);
  end;
end;

procedure DrawSnake();
var
  i: integer;
begin
  
  for i := 0 to snakeLength do
  begin
    if i = 0 then Brush.Color := clChocolate else Brush.Color := clGreen;
    FillRect(ceilSize * SnakeBody[i].x, ceilSize * SnakeBody[i].y, ceilSize * SnakeBody[i].x + ceilSize, ceilSize * SnakeBody[i].y + ceilSize);
  end;
  
  Brush.Color := clBlack;
end;

procedure NewApple();
var
  i: integer;
begin
  Randomize();
  Apple.x := Random(ROWS_COUNT);
  Apple.y := Random(COLS_COUNT);
  
  for i := 1 to snakeLength do
  begin
    if (Apple.x = SnakeBody[i].x) and (Apple.y = SnakeBody[i].y) then
    begin
      NewApple();
      break;
    end;
  end;
end;

procedure DrawApple();
begin
    Brush.Color := clGreenYellow;
    FillRect(ceilSize * Apple.x, ceilSize * Apple.y, ceilSize * Apple.x + ceilSize, ceilSize * Apple.y + ceilSize);
end;

procedure MoveSnake();
var
  i: integer;
begin

  for i := snakeLength downto 1 do 
  begin
    SnakeBody[i].x := SnakeBody[i - 1].x;
    SnakeBody[i].y := SnakeBody[i - 1].y;
  end;

  if direction = LEFT  then SnakeBody[0].x := SnakeBody[0].x - 1;
  if direction = RIGHT then SnakeBody[0].x :=  SnakeBody[0].x + 1;
  if direction = UP    then SnakeBody[0].y := SnakeBody[0].y - 1;
  if direction = DOWN  then SnakeBody[0].y := SnakeBody[0].y + 1;
  
  if ((SnakeBody[0].x =  Apple.x) and (SnakeBody[0].y = Apple.y)) then
  begin
    inc(snakeLength);
    inc(snakeSpeed);
    NewApple();
  end;
  
  if (snakeLength = MAX_SNAKE_LENGTH)then gameRunned := false;
  
  if (SnakeBody[0].x > ROWS_COUNT) then SnakeBody[0].x := 0;
  if (SnakeBody[0].x < 0) then SnakeBody[0].x := ROWS_COUNT;
  if (SnakeBody[0].y > COLS_COUNT) then SnakeBody[0].y := 0;
  if (SnakeBody[0].y < 0) then SnakeBody[0].y := COLS_COUNT;
  
  for i := 1 to snakeLength do
  begin
    if (SnakeBody[0].x = SnakeBody[i].x) and (SnakeBody[0].y = SnakeBody[i].y) then gameRunned := false;
  end; 
end;

procedure Draw();
begin
  LockDrawing();


  Window.Clear;

  DrawGrid();
  DrawSnake();
  DrawApple();
  
  Redraw();
  
  Sleep(500 div snakeSpeed);
end;

procedure Control(Key: integer);
begin

  case Key of
    VK_UP: if direction <> DOWN then direction := UP;
    VK_DOWN: if direction <> UP then direction := DOWN;
    VK_LEFT: if direction <> LEFT then direction := LEFT;
    VK_RIGHT: if direction <> RIGHT then direction := RIGHT;
    VK_SPACE: gameRunned     := not gameRunned;
  end;

end;
  
begin
  snakeSpeed := 2;
  Randomize();

  ceilSize     := 30;
  snakeLength := 4;
  
  direction := UP;

  Window.Caption := 'Snake';

  Window.Width  := ceilSize * ROWS_COUNT;
  Window.Height := ceilSize * COLS_COUNT;
  //Window.IsFixedSize := true;
  
  Window.CenterOnScreen;
  
  SnakeBody[0].x := Random(ROWS_COUNT);
  SnakeBody[0].y := Random(COLS_COUNT);
  
  for i := 1 to snakeLength do
  begin
    SnakeBody[i].x := SnakeBody[i - 1].x;
    SnakeBody[i].y := SnakeBody[i - 1].y + 1;
  end;
  
  OnKeyDown := Control;
  gameRunned := false;
  
  NewApple();
  Draw();
  
  while (true) do
  begin
    if (gameRunned)then
    begin
      Draw();
    
      MoveSnake();
    end;
  end;
end.

  
