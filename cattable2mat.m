function [dummytable,dummymat,dummyvarnames] = cattable2mat(data)
    % Makes a matrix from a table, with categorical variables
    % replaced by (numeric) dummy variables
    
    vars = string(data.Properties.VariableNames);
    idxCat = varfun(@iscategorical,data,"OutputFormat","uniform");
    
    for k = find(idxCat)
        % get list of categories
        c = categories(data.(vars(k)));
        
        % replace variable with matrix of dummy variables
        data = convertvars(data,vars(k),@dummyvar);
        
        % split dummy variable and make new variable names (by appending
        % the category value to the categorical variable name)
        varnames = vars(k) + "_" + replace(c," ","_");
        data = splitvars(data,vars(k),"NewVariableNames",varnames);
    end
    
    % return the numeric values
    dummymat = data.Variables;
    dummyvarnames = string(data.Properties.VariableNames);
    dummytable=array2table(dummymat,'VariableNames',dummyvarnames);
end