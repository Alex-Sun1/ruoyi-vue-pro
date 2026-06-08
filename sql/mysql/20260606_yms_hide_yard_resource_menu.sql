-- Hide the legacy YMS yard-zone / yard-position management entries.
-- Yard zones and parking slots are now managed by BASE yard_zone + yard_dock
-- through the dock settings page. Runtime YMS APIs remain available for dispatch,
-- yard map, gate and H5 check-in flows.

UPDATE system_menu
SET status = 1,
    update_time = NOW()
WHERE deleted = 0
  AND (
        id IN (
            SELECT id FROM (
                SELECT id
                FROM system_menu
                WHERE deleted = 0
                  AND (
                        path IN ('yms/zone', 'yms/yard-position')
                     OR component IN ('yms/zone/index', 'yms/yard-position/index')
                  )
            ) matched_parent
        )
     OR parent_id IN (
            SELECT id FROM (
                SELECT id
                FROM system_menu
                WHERE deleted = 0
                  AND (
                        path IN ('yms/zone', 'yms/yard-position')
                     OR component IN ('yms/zone/index', 'yms/yard-position/index')
                  )
            ) matched_parent_children
        )
  );
