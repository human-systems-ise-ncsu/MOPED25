%% To begin with
% This file introduces all the functionalities. Each block  
% introduces one function.

%% Load posture data of one task
% I copied one file to current folder for demo purpose.
% To access all data, you should download all using
%    the link on my github page. 
% Note that the 'file_dir' should be the directory of .mat file.
close all; clear; clc;

file_dir='\data\working_posture_trc_mat';

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
frame=get_one_frame(sub_id, task_id, task_iid, frame_id, ...
    file_dir);

% show the frame
imshow(frame);shg;

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










