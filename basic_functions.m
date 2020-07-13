%% To begin with
% This file introduces all the functionalities. Each block  
% introduces one function.
%% Set current working path !!!
cd path/to/current/mfile
% add functions path
addpath([pwd, '\funcs']);
%% Load posture data of one task
% I copied one file to current folder for demo purpose.
% To access all data, you should download all using
%    the link on my github page. 
% Note that the 'file_dir' should be the directory of .mat file.

close all; clear; clc;

file_dir='\data\working_posture_trc_mat'; % data directory

% Demo file name: 'sub07_09_01_trc.mat'.
sub_id=7; task_id=9; task_iid=1;

% get posture data from one task
pose_st=get_one_task(sub_id, task_id, task_iid, file_dir);
pose_st=pose_st.xyz_all;

% The first cell is frame id
frame_id=pose_st{1};
fprintf("Number of frames: %d\n", max(frame_id));

% The second cell is frame time for each frame
frame_time=pose_st{2};
fprintf("Length of the task: %f s\n", max(frame_time));

% summary
% The third cell is the marker data struct
marker_st=pose_st{3};
marker_name=marker_st(:,1); % marker name
% disp(marker_name');
marker_xyz=marker_st(:,2); % xyz for each marker

% To get marker data of forehead marker (FH)
FH_xyz=marker_xyz{1};

%% Load one frame from video 
% Similar to previous bloack, 
%   I copied one video file to current folder for demo purpose.
% To access all data, you should download all using
%    the link on my github page. 
% Note that the 'file_dir' should be the directory of .avi file.

file_dir='\data\working_posture_video';

% Demo file name: 'sub07_09_01.avi'.
sub_id=7; task_id=9; task_iid=1;

% get the frame
frame_id=3;
video_struct=get_one_frame(sub_id, task_id, task_iid, frame_id, ...
    file_dir);

% show the frame
imshow(video_struct.frame);shg;

%% visualize one pose
% Now, after running the previous two blocks, you should have
%    loaded the video and marker files.
% This block visualize the pose throgh connecting all markers.
close all;

% Visualize the 'nf' th frame
nf=10;
vis_pose_37(marker_xyz, nf);

% Play all frames of current task
vis_pose_37(marker_xyz);

%% load marker .trc file of box
% Demo file name: 'sub07_09_01_box_trc.mat'.
sub_id=7; task_id=9; task_iid=1;
% create file path
box_file_dir=fullfile('\data\box_trc_mat', ['sub', num_to_2char(sub_id)]);
box_file_name=[['sub', num_to_2char(sub_id)],'_',...
   num_to_2char(task_id), '_',  num_to_2char(task_iid),...
   '_box_trc.mat'];
box_file_path=fullfile(box_file_dir, box_file_name);
% load
box_marker_st=load(box_file_path);
box_marker_st=box_marker_st.box_xyz_all;

% summary
% The third cell is the marker data struct
disp(box_marker_st{3}(:,1));

box_marker_xyz=box_marker_st{3}(:,2); % xyz for each marker

%% load shelf and chair.trc file of box
% note that the shelf and chair were fixed

% create file path
chair_file_path='\data\virtual_trc\chair_virtual_trc.mat';
shelf_file_path='\data\virtual_trc\shelf_virtual_trc.mat';

% load
chair_marker_st=load(chair_file_path);
shelf_marker_st=load(shelf_file_path);

chair_marker_st=chair_marker_st.chair_xyz_all;
shelf_marker_st=shelf_marker_st.shelf_xyz_all;

% summary
% marker name
disp(chair_marker_st(:,1));
disp(shelf_marker_st(:,1));
% marker xyz
chair_marker_xyz=chair_marker_st(:,2);
shelf_marker_xyz=shelf_marker_st(:,2);




