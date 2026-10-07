% plot local truncation errors (currently for explicit methods)
function plot_local_truncation()

    
    [ex_mid_error, ex_mid_hlist] = local_truncation_error('Midpoint', ...
                                            @rate_func01, @solution01);
    
    [forward_eul_error, forward_eul_hlist] = local_truncation_error('Euler', ...
                                            @rate_func01, @solution01);
    
    % explicit method fit line
    log_exmid_hlist = log10(ex_mid_hlist)'
    log_exmid_error = log10(ex_mid_error)

    p = polyfit(log_exmid_hlist, log_exmid_error, 1)
    yfit = polyval(p, log_exmid_hlist);
    
    figure(1)
    loglog(10.^log_exmid_hlist, 10.^yfit, '-', 'Linewidth', 1.5, 'Displayname',"Exp. Mid. Fit");

    loglog(ex_mid_hlist, ex_mid_error, 'r.', 'Linewidth', 1.5,'Displayname',"Explicit Midpoint");
    hold on;
    loglog(forward_eul_hlist, forward_eul_error, 'b.', 'Linewidth', 1.5, 'Displayname',"Forward Euler");
    hold on;
    
    title('Local Trunction Errors for Explicit Methods', 'Interpreter', 'Latex', 'FontSize',18);
    legend('Location','northwest', 'Interpreter', 'Latex','FontSize',12)
    xlabel("Step size (h)", 'Interpreter', 'Latex','FontSize',16)
    ylabel("Measured LT error", 'Interpreter', 'Latex','FontSize',16)

   
   
end