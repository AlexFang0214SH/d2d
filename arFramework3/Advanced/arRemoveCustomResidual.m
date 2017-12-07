% function arRemoveCustomResidual( name )
%
% name indicates the name of the residuals. 'all' is also accepted to
% remove all residuals. To get a list of custom residuals currently
% specified, invoke arRemoveCustomResidual without any arguments
%
% Remove custom residuals


function arRemoveCustomResidual( name )
    global ar;

    if ( nargin < 1 )
        name = '<no name specified>';
    end
    
    % If it doesn't exist, create the structure
    if ( ~isfield( ar.config, 'user_residual_fun' ) || ( isempty( ar.config.user_residual_fun ) ) )
        warning( 'There are no custom residuals specified' );
        return;
    end

    if strcmp( name, 'all' )
        ar.config.user_residual_fun = [];
        
        % The objective function changed, so invalidate the cache!
        arCheckCache(1);
        return;
    end
    
    idx = find( strcmp( ar.config.user_residual_fun.name, name ) );
    if isempty( idx )
        warning( 'Did not find residual with name %s. Custom residuals currently specified are:\n%s\n > No residuals were removed!', name, sprintf( '%s\n', ar.config.user_residual_fun.name{:} ) );
    else
        ar.config.user_residual_fun.fn(idx) = [];
        ar.config.user_residual_fun.qFit(idx) = [];
        ar.config.user_residual_fun.name(idx) = [];
    end
    
    % The objective function changed, so invalidate the cache!
    arCheckCache(1);
end