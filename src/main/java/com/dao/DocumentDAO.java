package com.dao;

import java.util.List;
import com.model.Document;

public interface DocumentDAO {
    boolean addDocument(Document doc);
    List<Document> getDocumentsByUser(String email);
}