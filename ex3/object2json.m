function json=object2json(object) 
  % function json=object2json(object) 
  % This function returns a valid json string that will describe object 
  
  s=size(object); 
  if(all(s==1)) 
    % It's not a vector so we must check how to map it 
    % Depending on the class of the object we must do one or another thing 
    switch(class(object)) 
      case 'function_handle' 
        % For a function handle we will only print the name 
        fun=functions(object); 
        json=['"',fun.function,'"']; 
      case 'struct' 
        fields=fieldnames(object); 
        results=cellfun(@object2json,struct2cell(object),"UniformOutput",false); 
        json='{'; 
        if(numel(fields)>1) 
          sep=','; 
        else 
          sep=''; 
        endif 
        for(tmp=1:numel(fields)) 
          json=[json,'"',fields{tmp},'":',results{tmp},sep]; 
          if(tmp>=numel(fields)-1) 
            sep=''; 
          endif 
        endfor 
        json(end+1)='}'; 
      case 'cell' 
        % We dereference the cell and use it as a new value 
        json=object2json(object{1}); 
      case 'double' 
        if(isreal(object)) 
          json=num2str(object); 
        else 
          if(iscomplex(object)) 
            json=['{"real":',num2str(real(object)),',"imag:"',num2str(imag(object)),'}']; 
          endif 
        endif 
      case 'char' 
        % Here we handle a single char 
        json=['"',object,'"']; 
      otherwise 
        % We don't know what is it so we'll put the class name 
        json=['"',class(object),'"']; 
    endswitch 
  else 
    % It's a vector so it maps to an array 
    sep=''; 
    if(numel(s)>2) 
      json='['; 
      for(tmp=1:s(1)) 
        json=[json,sep,object2json(reshape(object(tmp,:),s(2:end)))]; 
        sep=','; 
      endfor 
      json(end+1)=']'; 
    else 
      % We can have three cases here: 
      % Object is a row -> array with all the elements 
      % Object is a column -> each element is an array in it's own 
      % Object is a 2D matrix -> separate each row 
      if(s(1)==1) 
        % Object is a row 
        if(ischar(object)) 
          % If it's a row of chars we will take it as a string 
          json=['"',object,'"']; 
        else 
          json='['; 
          for(tmp=1:s(2)) 
            json=[json,sep,object2json(object(1,tmp))]; 
            sep=','; 
          endfor 
          json(end+1)=']'; 
        endif 
      elseif(s(2)==1) 
        % Object is a column 
        json='['; 
        for(tmp=1:s(1)) 
          json=[json,'[',object2json(object(tmp,1)),']']; 
        endfor 
        json(end+1)=']'; 
      else 
        % Object is a 2D matrix 
        json='['; 
        for(tmp=1:s(1)) 
          json=[json,sep,object2json(object(tmp,:))]; 
          sep=','; 
        endfor 
        json(end+1)=']'; 
      endif 
    endif 
  endif 
endfunction

