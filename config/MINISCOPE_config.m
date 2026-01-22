%% MINISCOPE configuration
% created by YW. last update: 1/21/2026

pixel_size = 0.5;           % pixel size of your system 

vol_params.vol_sz    = [512*pixel_size,512*pixel_size,160*pixel_size];   % Volume size to sample (in microns)
vol_params.vol_depth = 30;  % Set the depth of imaging (depth at the middle of the simulated volume)
vol_params.neur_density = 1.2e4;
vol_params.vres         = 1 / pixel_size; % pixel size in tissue simulations; notice: it is pixel per micron!!
neur_params.avg_rad     = 4.5;  % for slightly larger neuron


%% widefield system parameters
FN = 18; % FN of objective, Olympus is 18, Nikon is 20, and Zeiss is 16.
M = 10; % system magnification

obj_immersion = 'air'; % or 'water'
psf_params.obj_fl = FN / M;
psf_params.objNA     = 0.5;  % emission NA 
psf_params.NA        = 0.5;  % excitation NA
psf_params.lambda = 0.488; % excitation wavelength
% psf_params.taillength = [];  % disable axial interpolation
psf_params.taillength = 40;   % microns, physical 1P axial support
psf_params.fineSamp   = [];  % disable fine sampling

if strcmp(obj_immersion, 'water')
    psf_params.zernikeWt  = [0 0 0 0.15 0 0 0 0 0 0 0]; % system aberrations
    wdm_params.nidx = 1.0;
elseif strcmp(obj_immersion, 'air')
    % add some SA
    psf_params.zernikeWt  = [0 0 0 0.1 0 0 0 0 0 0 0]; % 4th SA. 
    wdm_params.nidx = 1; % collection medium
else
    error('Require water or air as immersion medium!')
end
% z_range = min(vol_params.vol_sz(3), 150); % we maximize the size of 1P for better background simulations
% x_range = round(z_range / 4) - mod(round(z_range / 4), 4);
psf_params.psf_sz = [24, 24, 60];


%% widefield system parameters
spike_opts.prot = 'GCaMP6';
mode = 'wo_dend'; % choose the simulation to be with dendrites or not
if strcmp(mode, 'w_dend')
    spike_opts.dendflag = 1; % if the data is soma confined, set it to be 0;
elseif strcmp(mode, 'wo_dend')
    spike_opts.dendflag = 0; 
end

spike_opts.nt = 300;                                              % Set number of time step
spike_opts.nt = spike_opts.nt  + 100;                              % throw away start 100 frames
nt = spike_opts.nt - 100;
frate = 5;
spike_opts.dt = 1/frate;   % frame rate
spike_opts.rate  = 1e-3; % 0.25 for hawk, and 1e-3 for others
spike_opts.smod_flag = 'Ca_DE';  %  hawk or Ca_DE
spike_opts.p_off = -1;
%% widefield system parameters
wdm_params.lambda = 0.532; % emission wavelength
wdm_params.pavg = 1;                                                 % power in units of mW, for whole FOV
wdm_params.qe  = 0.7; % sensor QE
exp_level = 5; % control the brightness of neurons 

scan_params.motion = false; %  motion simulation flat=g
scan_params.verbose = 2; % details



%% check those parameters
vol_params   = check_vol_params(vol_params);                               % Check volume parameters
disp('Voxel grid size (px):')
disp(round(vol_params.vol_sz * vol_params.vres))
% --- FORCE vasculature volume to integer pixel grid ---
if isfield(vol_params,'vasc_sz') && ~isempty(vol_params.vasc_sz)
    vol_params.vasc_sz = round(vol_params.vasc_sz * vol_params.vres) ...
                          / vol_params.vres;
end

vasc_params  = check_vasc_params([]);                                      % Make default set of vasculature parameters
neur_params  = check_neur_params(neur_params);                                      % Make default set of neuron parameters
dend_params  = check_dend_params([]);                                      % Make default set of dendrite parameters
axon_params  = check_axon_params([]);                                      % Make default set of axon parameters
bg_params    = check_bg_params([]);                                        % Make default set of background parameters
spike_opts   = check_spike_opts(spike_opts);                               % Check spike/fluorescence simulation parameters
noise_params = check_noise_params([]);                                     % Make default noise parameter struct for missing elements
psf_params   = check_psf_params(psf_params);                               % Check point spread function parameters
scan_params  = check_imaging_params(scan_params);                                      % Check the scanning parameter struct
wdm_params   = check_wdm_params(wdm_params);                               % Check the auxiliary two-photon imaging parameter struct 
psf_params.sampling = 20; % the default value=200 is too large for miniscope 1-P data
psf_params.fastmask = false; % Disable fastmask and avoids all *_FM variables