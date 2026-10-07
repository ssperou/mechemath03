% plot local truncation errors (currently for explicit methods)
function plot_local_truncation()

    
    [ex_mid_error, ex_mid_hlist] = local_truncation_error('Midpoint', ...
                                            @rate_func01, @solution01);
    
    [forward_eul_error, forward_eul_hlist] = local_truncation_error('Euler', ...
                                            @rate_func01, @solution01);
    
    % explicit method fit line
    log_exmid_hlist = log10(ex_mid_hlist)'
    log_exmid_error = log10(ex_mid_error)

    ex_p = polyfit(log_exmid_hlist, log_exmid_error, 1)
    ex_yfit = polyval(ex_p, log_exmid_hlist);

    % Forward Euler fit line
    log_foreul_hlist = log10(forward_eul_hlist)'
    log_foreul_error = log10(forward_eul_error)

    foreul_p = polyfit(log_foreul_hlist, log_foreul_error, 1)
    foreul_yfit = polyval(foreul_p, log_foreul_hlist);
    
    figure(1)
    loglog(10.^log_exmid_hlist, 10.^ex_yfit, 'g-', 'Linewidth', 1.5, 'Displayname',"Exp. Mid. Fit");
    hold on;
    loglog(10.^log_foreul_hlist, 10.^foreul_yfit, 'm-', 'Linewidth', 1.5, 'Displayname',"Forw. Euler Fit");
    hold on;
    loglog(ex_mid_hlist, ex_mid_error, 'r.', 'Linewidth', 1.5,'Displayname',"Explicit Midpoint");
    hold on;
    loglog(forward_eul_hlist, forward_eul_error, 'b.', 'Linewidth', 1.5, 'Displayname',"Forward Euler");
    hold on;
    
    title('Local Trunction Errors for Explicit Methods', 'Interpreter', 'Latex', 'FontSize',18);
    legend('Location','northwest', 'Interpreter', 'Latex','FontSize',12)
    xlabel("Step size (h)", 'Interpreter', 'Latex','FontSize',16)
    ylabel("Measured LT error", 'Interpreter', 'Latex','FontSize',16)

   
   
end