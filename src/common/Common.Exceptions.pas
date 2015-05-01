unit Common.Exceptions;

interface
uses
  System.SysUtils;

type
  MenialTasksException = class(Exception);
    ModelException = class(MenialTasksException);

implementation

end.
