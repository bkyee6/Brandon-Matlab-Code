clear clc;
%obj = serial('com1'); % Win64
%Create serial object and connect to device
numato = serial('/dev/tty.usbmodem1421'); % Mac64
fopen(numato);
fprintf(numato, 'reset');
fprintf(numato, 'relay on 3');
fclose(numato);
%disp('properties');
%get(numato);
%fclose(numato);
%delete(numato);
%clear;