package com.eightam.lab.service;

import com.eightam.lab.dto.MerchantRequestResponse;
import com.eightam.lab.entity.MerchantRequest;
import com.eightam.lab.repository.MerchantRequestRepository;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

@Service
public class MerchantRequestService {

    private final MerchantRequestRepository merchantRequestRepository;

    public MerchantRequestService(MerchantRequestRepository merchantRequestRepository) {
        this.merchantRequestRepository = merchantRequestRepository;
    }

    public List<MerchantRequestResponse> listAll() {
        return merchantRequestRepository.findAllByOrderByCreatedAtDesc()
                .stream()
                .map(this::toResponse)
                .toList();
    }

    public MerchantRequestResponse approve(Long id) {
        MerchantRequest request = ensurePendingRequest(id);
        request.markApproved();
        return toResponse(merchantRequestRepository.save(request));
    }

    public MerchantRequestResponse reject(Long id) {
        MerchantRequest request = ensurePendingRequest(id);
        request.markRejected();
        return toResponse(merchantRequestRepository.save(request));
    }

    private MerchantRequest ensurePendingRequest(Long id) {
        MerchantRequest request = merchantRequestRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "å•†å®¶ç”³è¯·ä¸å­˜åœ¨"));
        if (request.isTerminal()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "æ­¤ç”³è¯·å·²å¤„ç†å®Œæ¯?");
        }
        return request;
    }

    private MerchantRequestResponse toResponse(MerchantRequest request) {
        return new MerchantRequestResponse(
                request.getId(),
                request.getMerchantName(),
                request.getApplicantName(),
                request.getContactPhone(),
                request.getLocation(),
                request.getNote(),
                request.getStatus().name(),
                request.getCreatedAt(),
                request.getProcessedAt()
        );
    }
}
