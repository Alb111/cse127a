class RoundRobinArbiter:
    """
    Round-Robin Arbiter

    Grants access to requesters in sequential order, cycling through all
    requesters equally. Each requester gets one grant per cycle when active,
    ensuring fair distribution regardless of request patterns.
    """
    def __init__(self, num_requesters):
        self.num_requesters = num_requesters
        self.last_grant = -1  # No grant yet

    def arbitrate(self, requests):
        """
        requests: list of booleans indicating active requests
        returns: index of granted requester or None
        """
        assert len(requests) == self.num_requesters

        # Start searching from the next requester
        for i in range(1, self.num_requesters + 1):
            idx = (self.last_grant + i) % self.num_requesters
            if requests[idx]:
                self.last_grant = idx
                return idx

        # No requests active
        return None
