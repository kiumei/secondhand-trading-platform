package com.campus.secondhand.market;

import com.campus.secondhand.common.PageQuery;
import com.campus.secondhand.common.PageResult;
import com.campus.secondhand.user.UserMapper;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import static com.campus.secondhand.market.MarketModels.*;
import static com.campus.secondhand.market.MarketRules.*;

@Service
@Profile("mysql")
public class CommunicationService {
    private final MarketMapper db;
    private final UserMapper users;
    public CommunicationService(MarketMapper db, UserMapper users) { this.db = db; this.users = users; }

    @Transactional
    public Message send(String user, MessageInput input) {
        found(users.findById(input.receiveUserId()));
        var message = new Message(null, user, input.receiveUserId(), input.content(), 0, now());
        var key = new com.campus.secondhand.common.GeneratedId();
        changed(db.insertMessage(message, key));
        return new Message(key.getId(), user, input.receiveUserId(), input.content(), 0, message.sendTime());
    }
    public PageResult<Message> messages(String user, String peer, PageQuery page) {
        require(peer != null && !peer.isBlank() && peer.length() <= 32, "接收人编号不正确");
        found(users.findById(peer));
        return new PageResult<>(db.messages(user, peer, page.getOffset(), page.getPageSize()),
                db.messageCount(user, peer), page.getPage(), page.getPageSize());
    }
    @Transactional
    public void read(String id, String user) {
        var message = found(db.message(id));
        allow(message.receiveUserId().equals(user));
        if (message.isRead() == 0) { db.readMessage(id, user); }
    }
    @Transactional
    public Report report(String user, ReportInput input) {
        require(input.reportType() != null && input.reportType().matches("[1-5]"), "举报类型必须为1至5");
        found(db.goods(input.goodsId()));
        var row = new Report(null, user, input.goodsId(), input.reportType(), input.reportContent(), input.proofImg(), 0, null);
        var key = new com.campus.secondhand.common.GeneratedId();
        changed(db.insertReport(row, key));
        return new Report(key.getId(), user, row.goodsId(), row.reportType(), row.reportContent(), row.proofImg(), 0, null);
    }

    public PageResult<Report> reports(String user, Integer status, PageQuery page) {
        require(status == null || status == 0 || status == 1, "举报处理状态不正确");
        return new PageResult<>(db.reports(user, status, page.getOffset(), page.getPageSize()),
                db.reportCount(user, status), page.getPage(), page.getPageSize());
    }
    @Transactional
    public Report handle(String id, String result) {
        found(db.report(id));
        changed(db.handleReport(id, result));
        return found(db.report(id));
    }
}
