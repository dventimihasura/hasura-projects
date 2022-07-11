update "order" set status = ((array['new', 'processing', 'fulfilled'])[floor(random()*3+1)])::status;
