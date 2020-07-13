function video_struct=get_one_frame(sub_id, task_id, task_iid, frame_id, ...
    file_dir)
% sub_id: subject id (2-12)
% task_id: task id (1-25)
% task_iid: some tasks have a few repetition, and some have different 
%   viewing angles. (1-4)
% file_dir: where you unpack the zip file, e.g. 
%   "xx/working_posture_video"

%% Check Input
idk=(task_id<=25)&(sub_id<=12)&(task_iid<=4);
assert(idk==true, 'Input number out of range');
%% get full path
file_dir=fullfile(file_dir, ['sub', num_to_2char(sub_id)]);
file_name=[['sub', num_to_2char(sub_id)],'_',...
   num_to_2char(task_id), '_',  num_to_2char(task_iid),...
   '.avi'];
file_path=fullfile(file_dir, file_name);
%% check file path
if ~exist(file_path)
    warning([file_name, ' does not exist']);
    pose_st=NaN;
    return;
end
%% get that frame
v = VideoReader(file_path);
frame_cnt=1;
 video_struct.total_frames=v.FrameRate*v.Duration;
 video_struct.duration=v.Duration;
 video_struct.fps=v.FrameRate;
while hasFrame(v)&&frame_cnt<=frame_id
    video_struct.frame = readFrame(v);
    frame_cnt=frame_cnt+1;
end

if frame_cnt<frame_id
    warning('Frame does not exist');
    video_struct=NaN;
end

