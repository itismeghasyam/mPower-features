%% unwrapfilemap

% Code for reading the filepathmap json and outputting three cells, one
% containing the fileids and one containing the corresponding file
% paths, and the other containing the corresponding filegroups

function [fileids,filepaths,filegroups] = unwrapfilemap(filename)
    filemap = loadjson(filename);
    fileids = filemap.recordId;
    filepaths = filemap.path;
    filegroups = filemap.group;
end