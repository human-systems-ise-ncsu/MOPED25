function fid=num_to_2char(id)

if id<10
    fid=['0', num2str(id)];
elseif id<100
    fid=num2str(id);
else
    printf("id should be within 0-99")
end
    