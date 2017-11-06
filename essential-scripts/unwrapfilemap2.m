%% unwrapfilemap2

% Code for reading the filepathmap json and outputting the corresponding
% filepaths

function [filepaths] = unwrapfilemap2(filename)
    filemap = loadjson(filename);
    filepaths = filemap.path;
end
