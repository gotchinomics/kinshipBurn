clc
clear all
close all

load channeling_events

% Loading data from the dynamic table into regular vectors
gotchis = channelingevents.Gotchi_id;
parcels = channelingevents.Realm_id;
FUD = channelingevents.FUD;
FOMO = channelingevents.FOMO;
ALPHA = channelingevents.ALPHA;
KEK = channelingevents.KEK;
spillover = channelingevents.spilloverRate/10000;

% Getting day of each channeling event
blockDateTime = char(channelingevents.evt_block_time);
blockDate = string(blockDateTime(:,1:10));

% Calculating kinship based on the amount of FUD produced per channeling
kinship = 50*(FUD/(20)).^2;

% Evaluating data, calculating events per day contained in the snapshot
figure('Color','white')
histogram(datetime(blockDate))
ylabel('# channelings analysed')
grid on

