% convert .mlx file to .m file
% This code allow you converting multiple files
%ex-  fileName=["evenodd","ievenodd"];
% mlx2m(fileName)

function []=mlx2m(fileNameInString)
tic
%preallocate the file size
mlx_file=fileNameInString;
m_file=fileNameInString;

% To make the .mlx and.m files
for i=1:length(fileNameInString)
    mlx_file(i) =strcat(fileNameInString(i),'.mlx');
    m_file(i) = strcat(fileNameInString(i),'.m');
end

%  Convert the .mlx file to .m file and dlete the .mlx file
for i=1:length(fileNameInString)
    matlab.internal.liveeditor.openAndConvert(convertStringsToChars(mlx_file(i)),convertStringsToChars(m_file(i))); % convert .mlx 2 .m
    delete (convertStringsToChars(mlx_file(i))); %delete the .mlx file
end
disp('All .mlx files convereted into .m files and deleted all .mlx files')
toc
end