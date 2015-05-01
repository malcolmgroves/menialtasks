unit Model.Exceptions;

interface
uses
  Common.Exceptions;

type
  TaskException = class(ModelException);
    PastTaskException = class(TaskException);
  NilParamException = class(TaskException);
  TaskListException = class(ModelException);
    DuplicateTaskException = class(TaskListException);


implementation

end.
